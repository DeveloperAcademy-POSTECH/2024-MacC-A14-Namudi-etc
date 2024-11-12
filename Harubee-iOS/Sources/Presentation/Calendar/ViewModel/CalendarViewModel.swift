//
//  CalendarViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

@Observable
final class CalendarViewModel {
  struct State {
    var currentBudget: SalaryBudget?
    var selectedDate: Date?
    var error: Error?
    
    static let initial = State()
  }
  
  struct PeriodDirectionState: Equatable {
    let canMovePrevious: Bool
    let canMoveNext: Bool
  }
  
  enum Action {
    case loadInitialData
    case updateCurrentData
    case movePeriod(PeriodDirection)
    case moveToCurrent
    case selectDate(Date)
    case updateMemo(MemoUpdate)
    case deleteMemo(String)
  }
  
  struct TransactionUpdate: Equatable {
    let income: Int?
    let expense: Int?
  }
  
  struct MemoUpdate: Equatable {
    let oldMemo: String?
    let newMemo: String
  }
  
  // MARK: - Properties
  private(set) var state: State
  private let budgetUseCase: BudgetUseCase
  private var allSalaryBudgets: [SalaryBudget] = []
  
  // MARK: - Computed Properties
  var periodDirectionState: PeriodDirectionState {
    guard let current = state.currentBudget else {
      return PeriodDirectionState(canMovePrevious: false, canMoveNext: false)
    }
    
    return PeriodDirectionState(
      canMovePrevious: hasPreviousBudget(from: current),
      canMoveNext: hasNextBudget(from: current)
    )
  }
  
  var isCurrentPeriodContainsToday: Bool {
    guard let budget = state.currentBudget else { return false }
    return budget.contains(date: Date())
  }
  
  var periodTitle: String {
    state.currentBudget.map { budget in
      "\(budget.startDate.formattedDateToString(.monthDay_dot)) - \(budget.endDate.formattedDateToString(.monthDay_dot))"
    } ?? ""
  }
  
  var selectedDailyBudget: DailyBudget? {
    guard let date = state.selectedDate,
          let budget = state.currentBudget else { return nil }
    return budget.dailyBudget(for: date)
  }
  
  // MARK: - Initialization
  init(
    budgetUseCase: BudgetUseCase,
    initialState: State = .initial
  ) {
    self.budgetUseCase = budgetUseCase
    self.state = initialState
  }
  
  // MARK: - Public Methods
  func send(_ action: Action) {
    switch action {
    case .loadInitialData:
      handleLoadInitialData()
    case .updateCurrentData:
      handleUpdateCurrentData()
    case .movePeriod(let direction):
      handleMovePeriod(direction)
    case .moveToCurrent:
      handleMoveToToday()
    case .selectDate(let date):
      handleSelectDate(date)
    case .updateMemo(let update):
      handleUpdateMemo(update)
    case .deleteMemo(let memo):
      handleDeleteMemo(memo)
    }
  }
  
  // MARK: - Private Methods
  private func handleLoadInitialData() {
    do {
      allSalaryBudgets = try loadBudgets()
      let today = Date().formattedDate
      
      guard let currentBudget = allSalaryBudgets.first(where: { $0.contains(date: today) })
      else {
        return
      }
      
      state.currentBudget = currentBudget
      state.selectedDate = today
      state.error = nil
      
    } catch {
      state.error = error
    }
  }
  
  private func handleUpdateCurrentData() {
    do {
      state.currentBudget = try budgetUseCase.getCurrentSalaryBudget(date: state.selectedDate)
    } catch {
      state.error = error
    }
  }
  
  private func handleMovePeriod(_ direction: PeriodDirection) {
    guard let current = state.currentBudget else { return }
    
    let nextBudget = findBudget(from: current, direction: direction)
    state.currentBudget = nextBudget
    
    if let budget = nextBudget,
       budget.contains(date: Date()) {
      state.selectedDate = Date().formattedDate
    }
  }
  
  private func handleMoveToToday() {
    let today = Date().formattedDate
    guard let todayBudget = allSalaryBudgets.first(where: { $0.contains(date: today) })
    else { return }
    
    state.currentBudget = todayBudget
    state.selectedDate = today
  }
  
  private func handleSelectDate(_ date: Date) {
    state.selectedDate = date.formattedDate
  }
  
  private func handleUpdateMemo(_ update: MemoUpdate) {
    guard let budget = selectedDailyBudget else { return }
    
    do {
      var updatedMemos = budget.memo
      
      if let oldMemo = update.oldMemo,
         let index = updatedMemos.firstIndex(of: oldMemo) {
        updatedMemos[index] = update.newMemo
      } else {
        updatedMemos.append(update.newMemo)
      }
      
      let updatedBudget = try budgetUseCase.updateMemoList(
        memoList: updatedMemos,
        dailyBudget: budget
      )
      updateDailyBudget(updatedBudget)
      
    } catch {
      state.error = error
    }
  }
  
  private func handleDeleteMemo(_ memo: String) {
    guard let budget = selectedDailyBudget else { return }
    
    do {
      var updatedMemos = budget.memo
      updatedMemos.removeAll { $0 == memo }
      
      let updatedBudget = try budgetUseCase.updateMemoList(
        memoList: updatedMemos,
        dailyBudget: budget
      )
      updateDailyBudget(updatedBudget)
      
    } catch {
      state.error = error
    }
  }
  
  // MARK: - Helper Methods
  private func loadBudgets() throws -> [SalaryBudget] {
    let budgets = try budgetUseCase.getAllSalaryBudget()
    return budgets.sorted { $0.startDate < $1.startDate }
  }
  
  private func findBudget(from current: SalaryBudget, direction: PeriodDirection) -> SalaryBudget? {
    switch direction {
    case .next:
      return allSalaryBudgets.first { $0.startDate > current.endDate }
    case .previous:
      return allSalaryBudgets.last { $0.endDate < current.startDate }
    }
  }
  
  private func hasPreviousBudget(from current: SalaryBudget) -> Bool {
    allSalaryBudgets.contains { $0.endDate < current.startDate }
  }
  
  private func hasNextBudget(from current: SalaryBudget) -> Bool {
    allSalaryBudgets.contains { $0.startDate > current.endDate }
  }
  
  private func updateBudget(_ updatedBudget: SalaryBudget) {
    guard let index = allSalaryBudgets.firstIndex(where: { $0.id == updatedBudget.id })
    else { return }
    
    allSalaryBudgets[index] = updatedBudget
    state.currentBudget = updatedBudget
    state.error = nil
  }
  
  private func updateDailyBudget(_ updatedBudget: DailyBudget) {
    guard var currentBudget = state.currentBudget,
          let index = currentBudget.dailyBudgets.firstIndex(where: { $0.id == updatedBudget.id })
    else { return }
    
    currentBudget.dailyBudgets[index] = updatedBudget
    state.currentBudget = currentBudget
  }
}

// MARK: - SalaryBudget Extensions
private extension SalaryBudget {
  func contains(date: Date) -> Bool {
    (startDate...endDate).contains(date)
  }
  
  func dailyBudget(for date: Date) -> DailyBudget? {
    dailyBudgets.first { $0.date.isSameDay(as: date) }
  }
}

// MARK: - Period Direction
enum PeriodDirection {
  case next, previous
  
  var offset: Int {
    switch self {
    case .next: return 1
    case .previous: return -1
    }
  }
  
  var imageName: String {
    switch self {
    case .next: return "chevron.right"
    case .previous: return "chevron.left"
    }
  }
}

//
//  CalendarViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftUI

@Observable
final class CalendarViewModel {
  // MARK: - State
  struct State {
    var currentBudget: SalaryBudget?
    var selectedDate: Date?
    var error: Error?
    
    static let initial = State(
      currentBudget: nil,
      selectedDate: nil,
      error: nil
    )
  }
  
  // MARK: - Action
  enum Action {
    case initialData
    case movePeriod(PeriodDirection)
    case moveToCurrent
    case selectDate(Date)
    case updateTransaction(income: Int?, expense: Int?)
    case addMemo(DailyBudget, String)
    case deleteMemo(DailyBudget, String)
  }
  
  // MARK: - Properties
  private(set) var state: State
  private let salaryBudgetUseCase: SalaryBudgetUseCase
  private let dailyBudgetUseCase: DailyBudgetUseCase
  private var allSalaryBudgets: [SalaryBudget] = []
  
  var canMovePrevious: Bool {
    guard let current = state.currentBudget else { return false }
    return allSalaryBudgets.contains { $0.endDate < current.startDate }
  }
  
  var canMoveNext: Bool {
    guard let current = state.currentBudget else { return false }
    return allSalaryBudgets.contains { $0.startDate > current.endDate }
  }
  
  var isCurrentPeriodContainsToday: Bool {
    guard let budget = state.currentBudget else { return false }
    let today = Date()
    return (budget.startDate...budget.endDate).contains(today)
  }
  
  var periodTitle: String {
    guard let budget = state.currentBudget else { return "" }
    return "\(budget.startDate.monthDayString) - \(budget.endDate.monthDayString)"
  }
  
  var selectedDailyBudget: DailyBudget? {
    guard let date = state.selectedDate,
          let budget = state.currentBudget else { return nil }
    return budget.dailyBudgets.first { $0.date.isSameDay(as: date) }
  }
  
  // MARK: - Initialization
  init(
    salaryBudgetUseCase: SalaryBudgetUseCase,
    dailyBudgetUseCase: DailyBudgetUseCase
  ) {
    self.salaryBudgetUseCase = salaryBudgetUseCase
    self.dailyBudgetUseCase = dailyBudgetUseCase
    self.state = .initial
  }
  
  // MARK: - Public Methods
  func send(_ action: Action) {
    switch action {
    case .initialData:
//      handleInitialData()
      loadTestData()
    case .movePeriod(let direction):
      handleMovePeriod(direction)
    case .moveToCurrent:
      handleMoveToToday()
    case .selectDate(let date):
      state.selectedDate = date
    case .updateTransaction(let income, let expense):
      handleUpdateTransaction(income: income, expense: expense)
    case .addMemo(let budget, let memo):
      handleAddMemo(memo, for: budget)
    case .deleteMemo(let budget, let memo):
      handleDeleteMemo(memo, from: budget)
    }
  }
  
  // MARK: - Private Methods
  private func handleInitialData() {
    do {
      allSalaryBudgets = try salaryBudgetUseCase.getAllSalaryBudget()
      let today = Date()
      state.currentBudget = try salaryBudgetUseCase.getCurrentSalaryBudget(date: today)
      state.selectedDate = today
      state.error = nil
    } catch {
      state.error = error
    }
  }
  
  private func loadTestData() {
    do {
      allSalaryBudgets = try SampleDataGenerator.createMultipleSampleBudgets(withError: false)
      let today = Date()
      state.currentBudget = allSalaryBudgets.first { budget in
        (budget.startDate...budget.endDate).contains(today)
      }
      state.selectedDate = today
      state.error = nil
    } catch {
      state.error = error
    }
  }
  
  private func handleMovePeriod(_ direction: PeriodDirection) {
    guard let current = state.currentBudget else { return }
    
    let nextBudget = direction == .next
    ? allSalaryBudgets.first { $0.startDate > current.endDate }
    : allSalaryBudgets.last { $0.endDate < current.startDate }
    
    state.currentBudget = nextBudget
    
    // 이동한 기간에 오늘 날짜가 포함되어 있다면 오늘 날짜 선택
    if let budget = nextBudget,
       (budget.startDate...budget.endDate).contains(Date()) {
      state.selectedDate = Date()
    }
  }
  
  private func handleMoveToToday() {
    let today = Date()
    if let todayBudget = allSalaryBudgets.first(where: { budget in
      (budget.startDate...budget.endDate).contains(today)
    }) {
      state.currentBudget = todayBudget
      state.selectedDate = today
    }
  }
  
  private func handleUpdateTransaction(income: Int?, expense: Int?) {
    guard let date = state.selectedDate,
          let budget = state.currentBudget else { return }
    
    do {
      let (_, updatedBudget) = try dailyBudgetUseCase.recordTransaction(
        expense: expense,
        income: income,
        date: date,
        salaryBudget: budget
      )
      
      if let index = allSalaryBudgets.firstIndex(where: { $0.id == budget.id }) {
        allSalaryBudgets[index] = updatedBudget
        state.currentBudget = updatedBudget
      }
      
      state.error = nil
    } catch {
      state.error = error
    }
  }
  
  private func handleAddMemo(_ memo: String, for dailyBudget: DailyBudget) {
    do {
      var memos = dailyBudget.memo
      memos.append(memo)
      
      let updatedBudget = try dailyBudgetUseCase.updateMemoList(
        memoList: memos,
        dailyBudget: dailyBudget
      )
      
      updateDailyBudget(updatedBudget)
      state.error = nil
    } catch {
      state.error = error
    }
  }
  
  private func handleDeleteMemo(_ memo: String, from dailyBudget: DailyBudget) {
    do {
      var memos = dailyBudget.memo
      memos.removeAll { $0 == memo }
      
      let updatedBudget = try dailyBudgetUseCase.updateMemoList(
        memoList: memos,
        dailyBudget: dailyBudget
      )
      
      updateDailyBudget(updatedBudget)
      state.error = nil
    } catch {
      state.error = error
    }
  }
  
  private func updateDailyBudget(_ updatedBudget: DailyBudget) {
    guard var currentBudget = state.currentBudget,
          let index = currentBudget.dailyBudgets.firstIndex(where: { $0.id == updatedBudget.id }) else { return }
    
    currentBudget.dailyBudgets[index] = updatedBudget
    state.currentBudget = currentBudget
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

//
//  CalendarViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Domain
import SwiftUI

// MARK: - Data Models
struct CalendarData {
  // 캘린더 셀(그리드)와 오늘 상세 정보에 제공되는 캘린더용 데이터 모델
  struct DayInfo {
    let date: Date
    let harubee: Int
    let isAdjusted: Bool
    let income: Int?
    let expense: Int?
    let memos: [String]
    let fixedExpenses: [FixedExpenseItem]
    
    var isOverHarubee: Bool {
      guard let expense else { return false }
      return expense >= harubee
    }
    
    var hasExpense: Bool {
      guard let expense else { return false }
      return expense > 0
    }
    
    static func from(
      dailyBudget: DailyBudget,
      defaultHarubee: Double,
      fixedExpenses: [TransactionItem]
    ) -> DayInfo {
      DayInfo(
        date: dailyBudget.date,
        harubee: dailyBudget.harubee ?? Int(defaultHarubee),
        isAdjusted: dailyBudget.harubee != nil,
        income: dailyBudget.income,
        expense: dailyBudget.expense,
        memos: dailyBudget.memo,
        fixedExpenses: fixedExpenses.filter {
          Calendar.current.isDate($0.date, equalTo: dailyBudget.date, toGranularity: .day)
        }.map({ item in
          FixedExpenseItem(from: item)
        })
      )
    }
  }
  
  struct FixedExpenseItem: Identifiable {
    let id: String
    let date: Date
    let name: String
    let amount: Int
    
    init(from domain: TransactionItem) {
      self.id = domain.id
      self.date = domain.date
      self.name = domain.name
      self.amount = domain.price
    }
  }
  
  struct Period {
    let start: Date
    let end: Date
  }
}

// MARK: - ViewModel
@Observable
final class CalendarViewModel {
  // MARK: - State
  struct State {
    var currentPeriod: CalendarData.Period
    var periodsCount: Int
    var dayInfos: [CalendarData.DayInfo]
    var selectedDate: Date?
    var currentBudgetIndex: Int
    var canMovePreviousPeriod: Bool
    var canMoveNextPeriod: Bool
    var error: Error?
    
    static let initial = State(
      currentPeriod: .init(start: .now, end: .now),
      periodsCount: 0,
      dayInfos: [],
      selectedDate: nil,
      currentBudgetIndex: 0,
      canMovePreviousPeriod: false,
      canMoveNextPeriod: false
    )
  }
  
  // MARK: - Action
  enum Action {
    case initialData
    case movePeriod(PeriodDirection)
    case dayCellSelected(Date)
    case saveTransaction(Int?, Int?)
    case saveMemo(CalendarData.DayInfo, String)
    case deleteMemo(CalendarData.DayInfo, String)
  }
  
  // MARK: - Properties
  private(set) var state: State
  private let salaryBudgetUseCase: SalaryBudgetUseCase
  private let dailyBudgetUseCase: DailyBudgetUseCase
  private var allSalaryBudgets: [SalaryBudget] = []
  
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
      loadInitialData()
      
    case .movePeriod(let direction):
      movePeriod(direction)
      
    case .dayCellSelected(let date):
      state.selectedDate = date
      
    case .saveTransaction(let income, let expense):
      handleTransaction(income: income, expense: expense)
      
    case .saveMemo(let dayInfo, let memo):
      handleMemo(for: dayInfo) { memos in
        memos.append(memo)
      }
      
    case .deleteMemo(let dayInfo, let memo):
      handleMemo(for: dayInfo) { memos in
        memos.removeAll { $0 == memo }
      }
    }
  }
  
  // MARK: - Private Methods
  private func loadInitialData() {
    do {
      allSalaryBudgets = try SampleDataGenerator.createMultipleSampleBudgets(withError: false)
      
      let today = Date().formattedDate
      if let (budget, index) = findBudgetAndIndex(for: today) {
        state.periodsCount = allSalaryBudgets.count
        state.currentBudgetIndex = index
        updateStateWithBudget(budget)
      } else {
        state.error = DomainError.dataNotFound
      }
    } catch {
      state.error = error
    }
  }
  
  private func findBudgetAndIndex(for date: Date) -> (SalaryBudget, Int)? {
    for (index, budget) in allSalaryBudgets.enumerated() where budget.containsDate(date) {
      return (budget, index)
    }
    return nil
  }
  
  private func updateStateWithBudget(_ budget: SalaryBudget) {
    state.currentPeriod = .init(start: budget.startDate, end: budget.endDate)
    state.selectedDate = nil
    state.dayInfos = budget.dailyBudgets.map {
      .from(dailyBudget: $0, defaultHarubee: budget.defaultHarubee, fixedExpenses: budget.fixedExpenses)
    }
    state.canMoveNextPeriod = state.currentBudgetIndex < allSalaryBudgets.count - 1
    state.canMovePreviousPeriod = state.currentBudgetIndex > 0
    state.error = nil
  }
  
  private func movePeriod(_ direction: PeriodDirection) {
    let canMove = direction == .next ? state.canMoveNextPeriod : state.canMovePreviousPeriod
    guard canMove else { return }
    
    let newIndex = state.currentBudgetIndex + direction.offset
    guard (0..<allSalaryBudgets.count).contains(newIndex) else { return }
    
    state.currentBudgetIndex = newIndex
    let budget = allSalaryBudgets[newIndex]
    updateStateWithBudget(budget)
    
    if budget.containsDate(Date()) {
      state.selectedDate = Date().formattedDate
    }
  }
  
  private func handleTransaction(income: Int?, expense: Int?) {
    guard let selectedDate = state.selectedDate,
          let dayInfo = state.dayInfos.first(where: { $0.date.isSameDay(as: selectedDate) })
    else {
      state.error = DomainError.dataNotFound
      return
    }
    
    do {
      let currentBudget = allSalaryBudgets[state.currentBudgetIndex]
      let (updatedDaily, updatedBudget) = try dailyBudgetUseCase.recordTransaction(
        expense: expense,
        income: income,
        date: selectedDate,
        salaryBudget: currentBudget
      )
      
      allSalaryBudgets[state.currentBudgetIndex] = updatedBudget
      
      if let index = state.dayInfos.firstIndex(where: { $0.date.isSameDay(as: selectedDate) }) {
        state.dayInfos[index] = .from(
          dailyBudget: updatedDaily,
          defaultHarubee: updatedBudget.defaultHarubee,
          fixedExpenses: dayInfo.fixedExpenses.map { item in
            TransactionItem(date: item.date, name: item.name, price: item.amount)
          }
        )
      }
    } catch {
      state.error = error
    }
  }
  
  private func handleMemo(
    for dayInfo: CalendarData.DayInfo,
    operation: (inout [String]) -> Void
  ) {
    do {
      let budget = try dailyBudgetUseCase.getDailyBudget(date: dayInfo.date)
      var memos = budget.memo
      operation(&memos)
      
      let updatedBudget = try dailyBudgetUseCase.updateMemoList(
        memoList: memos,
        dailyBudget: budget
      )
      
      if let index = state.dayInfos.firstIndex(where: { $0.date.isSameDay(as: dayInfo.date) }) {
        state.dayInfos[index] = .from(
          dailyBudget: updatedBudget,
          defaultHarubee: Double(dayInfo.harubee),
          fixedExpenses: dayInfo.fixedExpenses.map { item in
            TransactionItem(date: item.date, name: item.name, price: item.amount)
          }
        )
      }
    } catch {
      state.error = error
    }
  }
}

// MARK: - Supporting Types
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

// MARK: - Private Extensions
private extension SalaryBudget {
  func containsDate(_ date: Date) -> Bool {
    startDate <= date && date <= endDate
  }
}

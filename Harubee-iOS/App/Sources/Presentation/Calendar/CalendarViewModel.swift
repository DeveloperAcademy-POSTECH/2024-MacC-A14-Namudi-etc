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
struct CalendarDayInfo {
  let date: Date
  let harubee: Int
  let isAdjusted: Bool
  let expense: Int?
  let memos: [String]
  let todayFixedExpense: [TransactionItem]
  
  var isOverHarubee: Bool {
    guard let expense else { return false }
    return expense >= harubee
  }
  
  var hasExpense: Bool {
    guard let expense else { return false }
    return expense > 0
  }
  
  var expenseDiff: Int {
    guard let expense else { return 0 }
    return harubee - expense
  }
}

struct CalendarPeriod {
  let start: Date
  let end: Date
}

// MARK: - ViewModel
@Observable
final class CalendarViewModel {
  // MARK: - State
  struct State {
    // Data State
    var currentPeriod: CalendarPeriod
    var periodsCount: Int
    var dayInfos: [CalendarDayInfo]
    var selectedDate: Date?
    var currentBudgetIndex: Int
    
    // UI State
    var canMovePreviousPeriod: Bool
    var canMoveNextPeriod: Bool
    var error: Error?
    
    // Initial State
    static let initial = State(
      currentPeriod: CalendarPeriod(start: .now, end: .now),
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
    case moveNextPeriod
    case movePreviousPeriod
    case onDayCellSelected(Date)
  }
  
  // MARK: - Paging Direction
  enum Direction {
    case next
    case previous
    
    var indexOffset: Int {
      switch self {
      case .next: return 1
      case .previous: return -1
      }
    }
    
    var canMove: (CalendarViewModel.State) -> Bool {
      switch self {
      case .next: return { $0.canMoveNextPeriod }
      case .previous: return { $0.canMovePreviousPeriod }
      }
    }
  }
  
  // MARK: - Properties
  private(set) var state: State
  private let salaryBudgetUseCase: SalaryBudgetUseCase
  private var allSalaryBudgets: [SalaryBudget] = []
  
  // MARK: - Initialization
  init(salaryBudgetUseCase: SalaryBudgetUseCase) {
    self.salaryBudgetUseCase = salaryBudgetUseCase
    self.state = .initial
  }
  
  // MARK: - Public Methods
  func send(_ action: Action) {
    switch action {
    case .initialData:
      fetchAllPeriodData()
      print(#function, "loadData")
      
    case .moveNextPeriod:
      movePeriod(.next)
      print(#function, "moveNextPeriod")
      
    case .movePreviousPeriod:
      movePeriod(.previous)
      print(#function, "movePreviousPeriod")
      
    case .onDayCellSelected(let date):
      updateSelectedDate(date)
      print(#function, "onDayCellSelected(\(date.koreanFullDateString))")
    }
  }
  
  // MARK: - Private Methods
  private func fetchAllPeriodData() {
    do {
      // 1. 모든 기간의 SalaryBudget 가져와 캐싱하기
      /* self.allSalaryBudgets = try salaryBudgetUseCase.getAllSalaryBudget() */
      self.allSalaryBudgets = try SampleDataGenerator.createMultipleSampleBudgets(withError: false)
      let today = Date().formattedDate
      
      // 2. SalaryBudget의 Index를 구해 TabView에 바인딩
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
    for (index, budget) in allSalaryBudgets.enumerated() {
      if budget.startDate <= date && date <= budget.endDate {
        return (budget, index)
      }
    }
    return nil
  }
  
  private func updateStateWithBudget(_ budget: SalaryBudget) {
    let period = CalendarPeriod(start: budget.startDate, end: budget.endDate)
    
    let dayInfos = budget.dailyBudgets.map { dailyBudget in
      CalendarDayInfo(
        date: dailyBudget.date,
        harubee: dailyBudget.harubee ?? Int(budget.defaultHarubee),
        isAdjusted: dailyBudget.harubee != nil,
        expense: dailyBudget.expense,
        memos: dailyBudget.memo,
        todayFixedExpense: []
      )
    }
    
    // Update navigation state based on current index
    let canMovePrevious = state.currentBudgetIndex > 0
    let canMoveNext = state.currentBudgetIndex < allSalaryBudgets.count - 1
    
    state.selectedDate = nil
    state.currentPeriod = period
    state.dayInfos = dayInfos
    state.canMoveNextPeriod = canMoveNext
    state.canMovePreviousPeriod = canMovePrevious
    state.error = nil
  }
  
  private func movePeriod(_ direction: Direction) {
    guard direction.canMove(state) else { return }
    
    let newIndex = state.currentBudgetIndex + direction.indexOffset
    let isValidIndex = switch direction {
    case .next: newIndex < allSalaryBudgets.count
    case .previous: newIndex >= 0
    }
    
    guard isValidIndex else { return }
    
    state.currentBudgetIndex = newIndex
    let budget = allSalaryBudgets[newIndex]
    updateStateWithBudget(budget)
    
    // Select today if it's in the new period
    if budget.startDate <= Date() && Date() <= budget.endDate {
      updateSelectedDate(Date().formattedDate)
    }
  }
  
  private func updateSelectedDate(_ date: Date?) {
    state.selectedDate = date
  }
  
  // MARK: - Private Methods - Helpers
  private func checkCanMoveToNextPeriod(from date: Date) -> Bool {
    // 1. 다음 날짜 계산
    let nextDate = Calendar.current.date(
      byAdding: .day,
      value: 1,
      to: date
    ) ?? date
    
    // 3. 해당 날짜를 포함하는 SalaryBudget이 있는지 확인
    return allSalaryBudgets.contains { budget in
      budget.startDate <= nextDate && nextDate <= budget.endDate
    }
  }
  
  private func checkCanMoveToPreviousPeriod(from date: Date) -> Bool {
    // 2. 이전 날짜 계산
    let previousDate = Calendar.current.date(
      byAdding: .day,
      value: -1,
      to: date
    ) ?? date
    
    // 2. 해당 날짜를 포함하는 SalaryBudget이 있는지 확인
    return allSalaryBudgets.contains { budget in
      budget.startDate <= previousDate && previousDate <= budget.endDate
    }
  }
}

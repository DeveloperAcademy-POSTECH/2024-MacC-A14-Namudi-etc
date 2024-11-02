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
struct DayInfo {
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

struct Period {
  let start: Date
  let end: Date
}

// MARK: - ViewModel
@Observable
final class CalendarViewModel {
  // MARK: - State
  struct State {
    // Data State
    var currentPeriod: Period
    var dayInfos: [DayInfo]
    var selectedDate: Date?
    
    // UI State
    var canMovePreviousPeriod: Bool
    var canMoveNextPeriod: Bool
    var error: Error?
    
    static let initial = State(
      currentPeriod: Period(start: .now, end: .now),
      dayInfos: [],
      selectedDate: nil,
      canMovePreviousPeriod: false,
      canMoveNextPeriod: false
    )
  }
  
  // MARK: - Action
  enum Action {
    case loadData
    case moveNextPeriod
    case movePreviousPeriod
    case onDateSelected(Date)
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
    case .loadData:
      fetchAllPeriodData()
      print(#function, "loadData")
      
    case .moveNextPeriod:
      moveToNextPeriod()
      print(#function, "moveNextPeriod")
      
    case .movePreviousPeriod:
      moveToPreviousPeriod()
      print(#function, "movePreviousPeriod")
      
    case .onDateSelected(let date):
      updateSelectedDate(date)
      print(#function, "onDateSelected(\(date.koreanFullDateString))")
    }
  }
  
  // MARK: - Private Methods - Data Fetching
  private func fetchAllPeriodData() {
    do {
      // 1. 모든 기간의 SalaryBudget 가져와 캐싱하기
      /* self.allSalaryBudgets = try salaryBudgetUseCase.getAllSalaryBudget() */
      self.allSalaryBudgets = try SampleDataGenerator.createMultipleSampleBudgets()
      let today = Date().formattedDate
      
      // 4. 상태 업데이트하기 (메인스레드에서 이루어져야 함)
      await MainActor.run {
        state.currentPeriod = period
        state.dayInfos = dayInfos
        state.selectedDate = .now
        state.canMoveNextPeriod = canMoveNext
        state.canMovePreviousPeriod = canMovePrevious
        state.error = nil
      // 2. 오늘이 포함된 SalaryBudget 찾기
      guard let budget = allSalaryBudgets.first(where: { budget in
        budget.startDate <= today && today <= budget.endDate
      }) else {
        state.error = DomainError.dataNotFound
        return
      }
      
      // 3. 상태 업데이트하기
      updateStateWithBudget(budget)
      
    } catch {
      state.error = error
    }
  }
  
  private func updateStateWithBudget(_ budget: SalaryBudget) {
    // 1. 캘린더 기간 설정
    let period = Period(start: budget.startDate, end: budget.endDate)
    
    // 2. 뷰 데이터 모델로 변환
    let dayInfos = budget.dailyBudgets.map { dailyBudget in
      DayInfo(
        date: dailyBudget.date,
        harubee: dailyBudget.harubee ?? Int(budget.defaultHarubee),
        isAdjusted: dailyBudget.harubee != nil,
        expense: dailyBudget.expense,
        memos: dailyBudget.memo,
        todayFixedExpense: []
      )
    }
    
    // 3. 이전/다음 기간 이동 가능 여부 확인
    let canMoveNext = checkCanMoveToNextPeriod(from: budget.endDate)
    let canMovePrevious = checkCanMoveToPreviousPeriod(from: budget.startDate)
    
    // 4. 상태 업데이트
    state.selectedDate = nil
    state.currentPeriod = period
    state.dayInfos = dayInfos
    state.canMoveNextPeriod = canMoveNext
    state.canMovePreviousPeriod = canMovePrevious
    state.error = nil
  }
  
  private func moveToNextPeriod() {
    guard state.canMoveNextPeriod else { return }
    
    // 1. 다음 기간 시작일 계산
    let nextDate = Calendar.current.date(
      byAdding: .day,
      value: 1,
      to: state.currentPeriod.end
    ) ?? state.currentPeriod.end
    
    // 2. 캐시된 데이터에서 다음 기간 SalaryBudget 찾기
    if let nextBudget = allSalaryBudgets.first(where: { budget in
      budget.startDate <= nextDate && nextDate <= budget.endDate
    }) {
      // 3. 상태 업데이트
      updateStateWithBudget(nextBudget)
      
      // 4. 새 기간에 오늘이 포함되면 오늘 선택, 아니라면 미선택
      if nextBudget.startDate <= Date() && Date() >= nextBudget.endDate {
        updateSelectedDate(Date().formattedDate)
      } else {
        updateSelectedDate(nil)
      }
      
    }
  }
  
  private func moveToPreviousPeriod() {
    guard state.canMovePreviousPeriod else { return }
    
    // 1. 이전 기간 날짜 계산
    let previousDate = Calendar.current.date(
      byAdding: .day,
      value: -1,
      to: state.currentPeriod.start
    ) ?? state.currentPeriod.start
    
    // 2. 캐시된 데이터에서 이전 기간 SalaryBudget 찾기
    if let previousBudget = allSalaryBudgets.first(where: { budget in
      budget.startDate <= previousDate && previousDate <= budget.endDate
    }) {
      // 3. 상태 업데이트
      updateStateWithBudget(previousBudget)
      
      // 4. 새 기간에 오늘이 포함되면 오늘 선택, 아니라면 미선택
      if previousBudget.startDate <= Date() && Date() >= previousBudget.endDate {
        updateSelectedDate(Date().formattedDate)
      } else {
        updateSelectedDate(nil)
      }
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

//
//  CalendarViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Domain
import Foundation

// MARK: - Data Models
struct DayInfo {
  let date: Date
  let harubee: Int
  let isAdjusted: Bool
  let expense: Int?
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
    // Domain Data State
    var currentPeriod: Period
    var dayInfos: [DayInfo]
    var selectedDate: Date
    
    // UI State
    var canMovePreviousPeriod: Bool
    var canMoveNextPeriod: Bool
    var error: Error?
    
    static let initial = State(
      currentPeriod: Period(start: .now, end: .now),
      dayInfos: [],
      selectedDate: .now,
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
    case updateDayDetailInfo(Date)
  }
  
  // MARK: - Properties
  private(set) var state: State
  private let salaryBudgetUseCase: SalaryBudgetUseCase
  
  // MARK: - Initialization
  init(salaryBudgetUseCase: SalaryBudgetUseCase) {
    self.salaryBudgetUseCase = salaryBudgetUseCase
    self.state = .initial
  }
  
  // MARK: - Public Methods
  func send(_ action: Action) {
    switch action {
    case .loadData:
      Task {
        await fetchCurrentPeriodData()
        await fetchDayDetailInfo(Date())
      }
      print(#function, "loadData")
      
    case .moveNextPeriod:
      Task { await moveToNextPeriod() }
      print(#function, "moveNextPeriod")
      
    case .movePreviousPeriod:
      Task { await moveToPreviousPeriod() }
      print(#function, "movePreviousPeriod")
      
    case .onDateSelected(let date):
      updateSelectedDate(date)
      print(#function, "onDateSelected(\(date.koreanFullDateString))")
      
    case .updateDayDetailInfo(let date):
      Task { await fetchDayDetailInfo(date) }
      print(#function, "updateDayDetailInfo(\(date.koreanFullDateString))")
    }
  }
  
  // MARK: - Private Methods - Data Fetching
  
  // TODO: - 유즈케이스 구현 이후 비동기 함수인지 확인 필요
  private func fetchCurrentPeriodData() async {
    do {
      // 1. 현재 기간의 SalaryBudget 가져오기
      // guard let budget = try await salaryBudgetUseCase.getCurrentSalaryBudget() else { return }
      let budget = try SampleDataGenerator.createSampleSalaryBudget(withError: false)

      // 2. 캘린더 기간을 설정하고, DailyBudget을 각 셀에 들어갈 상태로 변환하기
      let period = Period(start: budget.startDate, end: budget.endDate)
      let dayInfos = budget.dailyBudgets.map { dailyBudget in
        DayInfo(
          date: dailyBudget.date,
          harubee: dailyBudget.harubee ?? Int(budget.defaultHarubee),
          isAdjusted: dailyBudget.harubee != nil,
          expense: dailyBudget.expense
        )
      }
      
      // 3. 이전 기간과 다음 기간으로 이동할 수 있는지 확인하기
      let canMoveNext = checkCanMoveToNextPeriod(from: budget.endDate)
      let canMovePrevious = await checkCanMoveToPreviousPeriod(from: budget.startDate)
      
      // 4. 상태 업데이트하기 (메인스레드에서 이루어져야 함)
      await MainActor.run {
        state.currentPeriod = period
        state.dayInfos = dayInfos
        state.selectedDate = .now
        state.canMoveNextPeriod = canMoveNext
        state.canMovePreviousPeriod = canMovePrevious
        state.error = nil
      }
      
    } catch {
      await MainActor.run {
        state.error = error
      }
    }
  }
  
  // TODO: - 유즈케이스 구현 이후 비동기 함수인지 확인 필요
  private func moveToNextPeriod() async {
    // 1. canMoveNextPeriod가 true인지 확인하기
    guard state.canMoveNextPeriod else { return }
    
    do {
      // 2. 다음 SalaryBudget이 존재하는지 확인하기
      guard let nextBudget = try await salaryBudgetUseCase.getSalaryBudget(
        for: state.currentPeriod.end.addingTimeInterval(86400)
      ) else { return }
      
      // 3. 캘린더 기간을 설정하고, DailyBudget을 각 셀에 들어갈 상태로 변환하기
      let period = Period(start: nextBudget.startDate, end: nextBudget.endDate)
      let dayInfos = nextBudget.dailyBudgets.map { dailyBudget in
        DayInfo(
          date: dailyBudget.date,
          harubee: dailyBudget.harubee ?? Int(nextBudget.defaultHarubee),
          isAdjusted: dailyBudget.harubee != nil,
          expense: dailyBudget.expense
        )
      }
      
      // 3. 다음 기간으로 이동할 수 있는지 확인하기
      let canMoveNext = checkCanMoveToNextPeriod(from: nextBudget.endDate)
      let canMovePrevious = true
      
      // 4. 상태 업데이트하기 (메인스레드에서 이루어져야 함)
      await MainActor.run {
        state.currentPeriod = period
        state.dayInfos = dayInfos
        state.selectedDate = period.start
        state.canMoveNextPeriod = canMoveNext
        state.canMovePreviousPeriod = canMovePrevious
        state.error = nil
      }
      
    } catch {
      await MainActor.run {
        state.error = error
      }
    }
  }
  
  // TODO: - 유즈케이스 구현 이후 비동기 함수인지 확인 필요
  private func moveToPreviousPeriod() async {
    // TODO: - 이전 기간으로 이동하는 로직 구현
    guard state.canMovePreviousPeriod else { return }
  }
  
  private func updateSelectedDate(_ date: Date) {
    state.selectedDate = date
  }
  
  // TODO: - 유즈케이스 구현 이후 비동기 함수인지 확인 필요
  private func fetchDayDetailInfo(_ date: Date) async {
    // TODO: - 일별 상세 뷰를 띄우기 위해 일별 데이터 가져오는 로직 구현 필요
  }
  
  // MARK: - Private Methods - Helpers
  
  private func checkCanMoveToNextPeriod(from date: Date) -> Bool {
    // 6개월 이내의 미래 날짜인지 확인하기
    // 지금은 미래 6개월까지만 이동할 수 있습니다.
    let sixMonthsLater = Calendar.current.date(
      byAdding: .month,
      value: 6,
      to: Date()
    ) ?? Date()
    return date < sixMonthsLater
  }
  
  // TODO: - 유즈케이스 구현 이후 비동기 함수인지 확인 필요
  private func checkCanMoveToPreviousPeriod(from date: Date) async -> Bool {
    do {
      // 1. 이전 기간의 마지막 날짜 구하기
      let previousDate = Calendar.current.date(
        byAdding: .day,
        value: -1,
        to: date
      ) ?? date
      
      // 2. 이전 기간의 마지막 날짜로 SalaryBudget이 있는지 확인하고 가져오기
      let previousBudget = try await salaryBudgetUseCase.getSalaryBudget(
        for: previousDate
      )
      return previousBudget != nil
      
    } catch {
      return false
    }
  }
}

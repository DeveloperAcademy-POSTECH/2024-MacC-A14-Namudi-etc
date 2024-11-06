//
//  OnboardingViewModel.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

@Observable
final class OnboardingViewModel {
  struct State {
    var incomeDay: Int = 1 // 고정 수입일
    var incomeAmount: Int? // 한달 수입금
    var previousExpense: Int? // 수입일 이후 지출 금액
    var fixedExpenses: [TransactionItem] = [] // 고정 지출 내역
    var averageHarubee: Int = 0 // 평균 하루비
    
    var incomeStartDate: Date {
      let calendar = Calendar.current
      let now = Date()
      
      var components = calendar.dateComponents([.year, .month, .day], from: now)
      
      if components.day! < incomeDay {
        components.month! -= 1
      }
      components.day! = incomeDay
      
      let startDate = calendar.date(from: components)!
      return startDate
    }
    
    var incomeEndDate: Date {
      let calendar = Calendar.current
      
      // startDate가 한 달의 시작 날짜가 됩니다.
      let startDate = incomeStartDate
      
      // startDate의 일자(day)를 기준으로 한 달 후의 날짜를 구함
      var components = calendar.dateComponents([.year, .month, .day], from: startDate)
      components.month! += 1 // 한 달 뒤로 설정
      
      // 다음 달에 동일한 일자가 있는지 확인하여 날짜를 생성
      if let calculatedEndDate = calendar.date(from: components) {
        return calculatedEndDate.addingTimeInterval(-86400)
      } else {
        // 동일 일자가 없는 경우(예: 30일이나 31일이 없는 달) 해당 월의 마지막 날로 조정
        var fallbackComponents = components
        fallbackComponents.day = calendar.range(of: .day, in: .month, for: calendar.date(from: components)!)?.last
        return calendar.date(from: fallbackComponents)!
      }
    }
  }
  
  enum Action {
    case nextButtonTapped(
      incomeDay: Int? = nil,
      incomeAmount: Int? = nil,
      previousExpense: Int? = nil,
      fixedExpenses: [TransactionItem] = []
    )
    case onAppear
    case updateFixedExpenses([TransactionItem])
    case finishButtonTapped
  }
  
  private let salaryBudgetUseCase: SalaryBudgetUseCase
  
  private(set) var state: State = .init()
  
  init(salaryBudgetUseCase: SalaryBudgetUseCase) {
    self.salaryBudgetUseCase = salaryBudgetUseCase
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      self.state.averageHarubee = self.calculateAverageHarubee()
      
    case let .nextButtonTapped(
      incomeDay,
      incomeAmount,
      previousExpense,
      fixedExpenses
    ):
      if let incomeDay = incomeDay { self.state.incomeDay = incomeDay }
      if let incomeAmount = incomeAmount { self.state.incomeAmount = incomeAmount }
      if let previousExpense = previousExpense { self.state.previousExpense = previousExpense }
      self.state.fixedExpenses = fixedExpenses
      
    case let .updateFixedExpenses(fixedExpenses):
      self.state.fixedExpenses = fixedExpenses
      self.state.averageHarubee = self.calculateAverageHarubee()
      
    case .finishButtonTapped:
      break
    }
  }
}

extension OnboardingViewModel {
  private func calculateAverageHarubee() -> Int {
    let balance = calculateBalance(
      incomeAmount: self.state.incomeAmount ?? 0,
      previousExpense: self.state.previousExpense ?? 0,
      fixedExpenses: self.state.fixedExpenses
    )
    
    let averageHarubee = (try? salaryBudgetUseCase.calculateAverageHarubee(
      endDate: self.state.incomeEndDate,
      balance: balance
    )) ?? 0
    
    return averageHarubee
  }
  
  private func calculateBalance(
    incomeAmount: Int,
    previousExpense: Int,
    fixedExpenses: [TransactionItem]
  ) -> Int {
    let totalExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    return incomeAmount - previousExpense - totalExpenses
  }
}

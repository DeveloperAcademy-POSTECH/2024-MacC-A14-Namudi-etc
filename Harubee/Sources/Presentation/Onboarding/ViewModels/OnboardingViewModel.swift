//
//  OnboardingViewModel.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

@Observable
final class OnboardingViewModel {
  struct State {
    var incomeDay: Int = 1 // 고정 수입일
    var incomeAmount: Int? // 한달 수입금
    var previousExpense: Int? // 수입일 이후 지출 금액
    var fixedExpenses: [TransactionItem] = [] // 고정 지출 내역
    var averageHarubee: Int = 0 // 평균 하루비
    
    var incomeStartDate: Date = .now
    var incomeEndDate: Date = .now
  }
  
  enum Action {
    case updateFixedIncomeDay(Int)
    case updateFixedIncomeAmount(Int)
    case updateFixedExpenses([TransactionItem])
    case updatePreviousExpense(Int)
    case finishOnboardingSetting
  }
  
  private let budgetUseCase: BudgetUseCase
  
  private(set) var state: State = .init()
  
  init(budgetUseCase: BudgetUseCase) {
    self.budgetUseCase = budgetUseCase
  }
  
  func send(_ action: Action) {
    switch action {
    case let .updateFixedIncomeDay(day):
      self.state.incomeDay = day
      
      let (start, end) = Date.calculateStartAndEndDate(from: day)
      self.state.incomeStartDate = start
      self.state.incomeEndDate = end
      
    case let .updateFixedIncomeAmount(amount):
      self.state.incomeAmount = amount
      
    case let .updateFixedExpenses(fixedExpenses):
      self.state.fixedExpenses = fixedExpenses
      
    case let .updatePreviousExpense(previousExpense):
      self.state.previousExpense = previousExpense
      
    case .finishOnboardingSetting:
      let _ = try? budgetUseCase.createSalaryBudgetFromOnboarding(
        startDate: self.state.incomeStartDate,
        endDate: self.state.incomeEndDate,
        previousExpense: self.state.previousExpense,
        fixedIncome: self.state.incomeAmount ?? 0,
        fixedExpenses: self.state.fixedExpenses
      )
    }
    
    self.state.averageHarubee = self.calculateAverageHarubee()
  }
}

extension OnboardingViewModel {
  private func calculateAverageHarubee() -> Int {
    let balance = calculateBalance(
      incomeAmount: self.state.incomeAmount ?? 0,
      previousExpense: self.state.previousExpense ?? 0,
      fixedExpenses: self.state.fixedExpenses
    )
    
    let averageHarubee = budgetUseCase.calculateAverageHarubee(
      endDate: self.state.incomeEndDate,
      balance: balance
    )
    
    return Int(averageHarubee)
  }
  
  private func calculateBalance(
    incomeAmount: Int,
    previousExpense: Int,
    fixedExpenses: [TransactionItem]
  ) -> Int {
    let now = Date().formattedDate
    let totalExpenses = fixedExpenses.filter { $0.date > now }.reduce(0) { $0 + $1.price }
    return incomeAmount - previousExpense - totalExpenses
  }
}

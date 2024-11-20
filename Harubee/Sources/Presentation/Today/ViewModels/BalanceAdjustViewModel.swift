//
//  BalanceAdjustViewModel.swift
//  Harubee-iOS
//
//  Created by 신승재 on 11/18/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

@Observable
final class BalanceAdjustViewModel {
  
  struct State {
    var salaryBudget: SalaryBudget
    var dailyBudget: DailyBudget
    
    var balance: Int = 0
    var totalFixedExpense: Int = 0
    var realBalance: Int = 0
  }
  
  enum Action {
    case doneButtonTapped(Int?)
    case saveButtonTapped
  }
  
  private let budgetUseCase: BudgetUseCase
  
  private(set) var state: State
  
  init(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget,
    budgetUseCase: BudgetUseCase
  ) {
    self.budgetUseCase = budgetUseCase
    
    let balance = salaryBudget.balance
    
    // 오늘 날짜부터 다음 수입일까지의 고정지출액
    let totalFixedExpense = salaryBudget.fixedExpenses
      .filter { $0.date >= Date().formattedDate }
      .reduce(0) { $0 + $1.price }
    
    self.state = .init(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget,
      balance: balance,
      totalFixedExpense: totalFixedExpense,
      realBalance: balance + totalFixedExpense
    )
  }
  
  func send(_ action: Action) {
    switch action {
    case let .doneButtonTapped(realBalance):
      self.state.balance = realBalance! - state.totalFixedExpense
      self.state.realBalance = realBalance!
      
    case .saveButtonTapped:
      do {
        let _ = try self.budgetUseCase.updateBalance(
          salaryBudget: state.salaryBudget, newBalance: state.balance
        )
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

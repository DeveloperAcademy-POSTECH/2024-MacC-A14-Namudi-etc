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
    self.state = .init(salaryBudget: salaryBudget, dailyBudget: dailyBudget)
    self.budgetUseCase = budgetUseCase
    let balance = Int(salaryBudget.balance)
    let totalFixedExpense = salaryBudget.fixedExpenses.reduce(0) {
      $0 + $1.price
    }
    self.state.totalFixedExpense = totalFixedExpense
    self.state.balance = balance
    self.state.realBalance = balance + totalFixedExpense
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

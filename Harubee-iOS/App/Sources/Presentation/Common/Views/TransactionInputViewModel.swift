//
//  TransactionInputViewModel.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/10/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

@Observable
final class TransactionInputViewModel {
  struct State {
    var salaryBudget: SalaryBudget
    var dailyBudget: DailyBudget
  }
  
  enum Action {
    case doneButtonTapped(Int, Bool)
    case resetButtonTapped(Int, Bool)
    case saveButtonTapped
  }
  
  private let budgetUseCase: BudgetUseCase
  
  private(set) var state: State
  
  init(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget,
    budgetUseCase: BudgetUseCase
  ) {
    self.state = State(salaryBudget: salaryBudget, dailyBudget: dailyBudget)
    self.budgetUseCase = budgetUseCase
  }
  
  func send(_ action: Action) {
    switch action {
    case .doneButtonTapped(let amount, let isExpense):
      self.updateTransaction(amount: amount, isExpense: isExpense)
    case .resetButtonTapped(let amount, let isExpense):
      self.updateTransaction(amount: amount, isExpense: isExpense)
    case .saveButtonTapped:
      do {
        let (salary, daily) = try self.budgetUseCase.recordTransaction(
          expense: self.state.dailyBudget.expense,
          income: self.state.dailyBudget.income,
          date: self.state.dailyBudget.date,
          salaryBudget: self.state.salaryBudget
        )
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

extension TransactionInputViewModel {
  private func updateTransaction(amount: Int, isExpense: Bool) {
    if isExpense {
      self.state.dailyBudget.expense = amount
    } else {
      self.state.dailyBudget.income = amount
    }
  }
}

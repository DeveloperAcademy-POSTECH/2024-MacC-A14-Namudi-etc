//
//  TransactionInputViewModel.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/10/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

@Observable
final class TransactionInputViewModel {
  struct State {
    var salaryBudget: SalaryBudget
    var dailyBudget: DailyBudget
    
    var updatedExpense: Int?
    var updatedIncome: Int?
  }
  
  enum Action {
    case doneButtonTapped(String, String)
    case saveButtonTapped
  }
  
  private let budgetUseCase: BudgetUseCase
  private let analyticsUseCase: AnalyticsUseCase
  
  private(set) var state: State
  
  init(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget,
    budgetUseCase: BudgetUseCase,
    analyticsUseCase: AnalyticsUseCase
  ) {
    self.state = State(salaryBudget: salaryBudget, dailyBudget: dailyBudget)
    self.budgetUseCase = budgetUseCase
    self.analyticsUseCase = analyticsUseCase
  }
  
  func send(_ action: Action) {
    switch action {
    case .doneButtonTapped(let income, let expense):
      self.state.updatedIncome = income.numberFormat
      self.state.updatedExpense = expense.numberFormat
      
    case .saveButtonTapped:
      do {
        let _ = try self.budgetUseCase.recordTransaction(
          expense: self.state.updatedExpense,
          income: self.state.updatedIncome,
          date: self.state.dailyBudget.date,
          salaryBudget: self.state.salaryBudget
        )
        analyticsUseCase.trackEvent(
          event: .buttonTap(name: "실제 지출 입력")
        )
        WidgetManager.shared.enableReload()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

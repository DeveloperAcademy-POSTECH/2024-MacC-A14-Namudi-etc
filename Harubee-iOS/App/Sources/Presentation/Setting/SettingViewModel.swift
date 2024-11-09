//
//  SettingViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

@Observable
final class SettingViewModel {
  struct State {
    // MARK: FixedIncomeView
    var salaryBudget: SalaryBudget?
  }
  
  enum Action {
    // MARK: FixedIncomeView
    case saveButtonTapped(Int?, Int?)
  }
  
  private(set) var state = State()
  
  private let budgetUseCase = DIContainer.shared.makeBudgetUseCase()
  
  init(salaryBudget: SalaryBudget) {
    self.state.salaryBudget = salaryBudget
  }
  
  // MARK: - Public Methods (유저 액션 핸들러)
  func send(_ action: Action) {
    switch action {
    case .saveButtonTapped(let incomeDay, let incomeAmount):
      if let incomeDay = incomeDay {
        self.updateFixedIncomeDay(incomeDay)
      }
      
      if let incomeAmount = incomeAmount {
        self.updateFixedIncomeAmount(incomeAmount)
      }
    }
  }
    
    // MARK: - Private Methods (유즈케이스 호출 메소드)
    private func updateFixedIncomeDay(_ incomeDay: Int) {
      do {
        try budgetUseCase.setIncomeDay(day: incomeDay)
        let updatedSalaryBudget = try budgetUseCase.getSalaryBudget(startDate: Date())
        self.state.salaryBudget = updatedSalaryBudget
      } catch {
        print("error: \(error.localizedDescription)")
      }
    }
    
    private func updateFixedIncomeAmount(_ incomeAmount: Int) {
      do {
        if let salaryBudget = self.state.salaryBudget {
          try budgetUseCase.updateFixedIncome(salaryBudget: salaryBudget,
                                              newIncome: incomeAmount
          )
          let updatedSalaryBudget = try budgetUseCase.getSalaryBudget(startDate: Date())
          self.state.salaryBudget = updatedSalaryBudget
        }
      } catch {
        print("error: \(error.localizedDescription)")
      }
    }
  }

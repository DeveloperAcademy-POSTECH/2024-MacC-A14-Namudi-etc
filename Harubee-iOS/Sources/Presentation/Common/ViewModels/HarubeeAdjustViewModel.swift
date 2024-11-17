//
//  HarubeeAdjustViewModel.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/10/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

@Observable
final class HarubeeAdjustViewModel {
  
  struct State {
    var salaryBudget: SalaryBudget
    var dailyBudget: DailyBudget
    
    var defaultHarubee: Int = 0
    var updatedHarubee: Int = 0
    
    // alert
    var defaultHarubeeForAlert: Int = 0
  }
  
  enum Action {
    case doneButtonTapped(Int?)
    case resetButtonTapped
    case resetDoneButtonTapped
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
    
    self.state.defaultHarubee = Int(salaryBudget.defaultHarubee)
    self.state.updatedHarubee = dailyBudget.harubee ?? self.state.defaultHarubee
  }
  
  func send(_ action: Action) {
    switch action {
    case let .doneButtonTapped(harubee):
      updateHarubee(harubee)
      
    case .resetButtonTapped:
      self.state.defaultHarubeeForAlert = calculateDefaultHarubee()
      
    case .resetDoneButtonTapped:
      updateHarubee(nil)
      
      do {
        let _ = try self.budgetUseCase.adjustHarubee(
          amount: self.state.dailyBudget.harubee,
          date: self.state.dailyBudget.date,
          salaryBudget: self.state.salaryBudget
        )
      } catch {
        print(error.localizedDescription)
      }
      
    case .saveButtonTapped:
      do {
        let _ = try self.budgetUseCase.adjustHarubee(
          amount: self.state.dailyBudget.harubee,
          date: self.state.dailyBudget.date,
          salaryBudget: self.state.salaryBudget
        )
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

extension HarubeeAdjustViewModel {
  private func updateHarubee(_ harubee: Int?) {
    
    // DailyBudget의 하루비 업데이트
    self.state.dailyBudget.harubee = harubee
    
    // SalaryBudget.dailyBudgets 업데이트
    if let index = self.state.salaryBudget.dailyBudgets.firstIndex(where: {
      $0.id == self.state.dailyBudget.id
    }) {
      self.state.salaryBudget.dailyBudgets[index].harubee = harubee
    }
    
    // 기본 하루비 계산
    let defaultHarubee = self.budgetUseCase.calculateDefaultHarubee(
      salaryBudget: self.state.salaryBudget
    )
    
    // SalaryBudget에 새로운 기본 하루비 저장
    self.state.salaryBudget.defaultHarubee = defaultHarubee
  }
  
  private func calculateDefaultHarubee() -> Int {
    var salaryBudget = self.state.salaryBudget
    
    if let index = salaryBudget.dailyBudgets.firstIndex(where: {
      $0.id == self.state.dailyBudget.id
    }) {
      salaryBudget.dailyBudgets[index].harubee = nil
    }
    
    // 기본 하루비 계산
    let defaultHarubee = self.budgetUseCase.calculateDefaultHarubee(
      salaryBudget: salaryBudget
    )
    
    return Int(defaultHarubee)
  }
}

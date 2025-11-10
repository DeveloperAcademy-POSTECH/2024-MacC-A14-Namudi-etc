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
  private let analyticsUseCase: AnalyticsUseCase
  
  private(set) var state: State
  
  init(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget,
    budgetUseCase: BudgetUseCase,
    analyticsUseCase: AnalyticsUseCase
  ) {
    self.state = .init(salaryBudget: salaryBudget, dailyBudget: dailyBudget)
    self.budgetUseCase = budgetUseCase
    self.analyticsUseCase = analyticsUseCase
    
    self.state.defaultHarubee = Int(salaryBudget.defaultHarubee)
    self.state.updatedHarubee = dailyBudget.harubee ?? self.state.defaultHarubee
  }
  
  func send(_ action: Action) {
    switch action {
    case let .doneButtonTapped(harubee):
      self.state.updatedHarubee = harubee ?? 0
      self.state.defaultHarubee = calculateDefaultHarubee(harubee)
      
    case .resetButtonTapped:
      self.state.defaultHarubeeForAlert = calculateDefaultHarubee(nil)
      
    case .resetDoneButtonTapped:
      do {
        let _ = try self.budgetUseCase.adjustHarubee(
          amount: nil,
          date: self.state.dailyBudget.date,
          salaryBudget: self.state.salaryBudget
        )
        analyticsUseCase.trackEvent(
          event: .buttonTap(name: "하루비 초기화")
        )
        
      } catch {
        print(error.localizedDescription)
      }
      
    case .saveButtonTapped:
      do {
        let _ = try self.budgetUseCase.adjustHarubee(
          amount: self.state.updatedHarubee,
          date: self.state.dailyBudget.date,
          salaryBudget: self.state.salaryBudget
        )
        analyticsUseCase.trackEvent(
          event: .buttonTap(name: "하루비 조정")
        )
        WidgetManager.shared.enableReload()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

extension HarubeeAdjustViewModel {
  
  private func calculateDefaultHarubee(_ todayHarubee: Int?) -> Int {
    var salaryBudget = self.state.salaryBudget
    
    if let index = salaryBudget.dailyBudgets.firstIndex(where: {
      $0.id == self.state.dailyBudget.id
    }) {
      salaryBudget.dailyBudgets[index].harubee = todayHarubee
    }
    
    // 기본 하루비 계산
    let defaultHarubee = self.budgetUseCase.calculateDefaultHarubee(
      salaryBudget: salaryBudget,
      anchorDate: .now
    )
    
    return Int(defaultHarubee)
  }
}

//
//  HarubeeWidgetEntryViewModel.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/21/24.
//

import Foundation

@Observable
final class HarubeeWidgetEntryViewModel {
  struct State {
    var salarYBudget: SalaryBudget?
  }
  
  enum Action {
    case reload
    
  }
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  
  private(set) var state: State = State()
  
  init(salaryBudgetRepository: SalaryBudgetRepository) {
    self.salaryBudgetRepository = salaryBudgetRepository
  }
}

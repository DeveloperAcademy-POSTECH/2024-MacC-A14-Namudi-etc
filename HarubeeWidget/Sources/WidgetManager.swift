//
//  WidgetManager.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/21/24.
//

import Foundation


struct WidgetManager {
  
  static let shared = WidgetManager()
  
  private init() {
    self.salaryBudgetRepository = SalaryBudgetRepositoryImpl(
      modelContext: StorageProvider().modelContext
    )
  }
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  
  func fetchSalaryBudget() -> SalaryBudget? {
    let salaryBudget = try? salaryBudgetRepository.readByTargetDateContaining(.now)
    return salaryBudget
  }
}

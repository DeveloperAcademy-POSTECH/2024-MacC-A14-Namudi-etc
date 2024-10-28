//
//  BudgetPeriodUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class SalaryBudgetUseCaseImpl: SalaryBudgetUseCase {
  
  public init(
    salaryBudgetRepository: SalaryBudgetRepository,
    calculationUseCase: BudgetCalculationUseCase
  ) {
    
  }
  
  public func createSalaryBudget(startDate: Date, endDate: Date, fixedIncome: Int, fixedExpenses: [TransactionItem]) async throws -> SalaryBudget {
    
    return SalaryBudget.default
  }
  
  public func getCurrentSalaryBudget() async throws -> SalaryBudget? {
    
    return SalaryBudget.default
  }
  
  public func getSalaryBudget(for date: Date) async throws -> SalaryBudget? {
    
    return SalaryBudget.default
  }
  
  public func updateBalance(for salaryBudget: SalaryBudget, newBalance: Int) async throws {
    
    return
  }
}

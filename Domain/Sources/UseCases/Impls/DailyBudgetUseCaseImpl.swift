//
//  DailyBudgetUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class DailyBudgetUseCaseImpl: DailyBudgetUseCase {
  
  public init(
    budgetRepository: BudgetRepository,
    calculationUseCase: BudgetCalculationUseCase
  ) {
    
  }
  
  public func adjustDailyBudget(to amount: Int, for date: Date, in salaryBudget: SalaryBudget) async throws -> SalaryBudget {
    
    return SalaryBudget.default
  }
  
  public func recordExpense(to expense: Int, for date: Date, in salaryBudget: SalaryBudget) async throws -> SalaryBudget {
    
    return SalaryBudget.default
  }
  
  public func recordIncome(to income: Int, for date: Date, in salaryBudget: SalaryBudget) async throws -> SalaryBudget {
    
    return SalaryBudget.default
  }
  
  public func addMemo(to memo: String, for date: Date) async throws -> DailyBudget {
    
    return DailyBudget.default
  }
  
  public func deleteMemo(to memo: String, for date: Date) async throws -> DailyBudget {
    
    return DailyBudget.default
  }
}

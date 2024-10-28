//
//  BudgetCalculationUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class BudgetCalculationUseCaseImpl: BudgetCalculationUseCase {
  
  public init(
    salaryBudgetRepository: SalaryBudgetRepository
  ) {
    
  }
  
  public func calculateDefaultHarubee(balance: Int, from startDate: Date, to endDate: Date) async throws -> Int {
    
    return 0
  }
  
  public func calculateAverageHarubee(for salaryBudget: SalaryBudget, from fromDate: Date?) async throws -> Int {
    
    return 0
  }
}

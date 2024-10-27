//
//  BudgetRepositoryImpl.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftData

public final class BudgetRepositoryImpl: BudgetRepository {
  
  public init(modelContainer: ModelContainer) {
    
  }
  
  public func saveSalaryBudget(_ salaryBudget: Domain.SalaryBudget) async throws {
    return
  }
  
  public func getSalaryBudget(containing date: Date) async throws -> Domain.SalaryBudget? {
    return nil
  }
  
  public func getAllSalaryBudgets() async throws -> [Domain.SalaryBudget] {
    return []
  }
  
  public func saveDailyBudget(_ dailyBudget: Domain.DailyBudget, for date: Date) async throws {
    return
  }
  
  public func getDailyBudget(for date: Date) async throws -> Domain.DailyBudget? {
    return nil
  }
  
  public func getDailyBudgets(from startDate: Date, to endDate: Date) async throws -> [Domain.DailyBudget] {
    return []
  }
}

//
//  SalaryBudgetRepositoryImpl.swift
//  Data
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftData

public final class SalaryBudgetRepositoryImpl: SalaryBudgetRepository {
  
  private let modelContainer: ModelContainer
  
  public init(modelContainer: ModelContainer) {
    self.modelContainer = modelContainer
  }
  
  public func create(_ salaryBudget: Domain.SalaryBudget) async throws {
    print("Impl:", #function)
    return
  }
  
  public func readAll() async throws -> [Domain.SalaryBudget] {
    print("Impl:", #function)
    return []
  }
  
  public func readByStartDate(_ startDate: Date) async throws -> Domain.SalaryBudget? {
    print("Impl:", #function)
    return nil
  }
  
  public func updateTotalFixedIncome(_ id: String, totalFixedIncome: Int) async throws {
    print("Impl:", #function)
    return
  }
  
  public func updateFixedExpenses(_ id: String, fixedExpenses: [Domain.TransactionItem]) async throws {
    print("Impl:", #function)
    return
  }
  
  public func updateBalance(_ id: String, balance: Int) async throws {
    print("Impl:", #function)
    return
  }
  
  public func updateDefaultHarubee(_ id: String, defaultHarubee: Double) async throws {
    print("Impl:", #function)
    return
  }
  
  public func deleteById(_ id: String) async throws {
    print("Impl:", #function)
    return
  }
  
  
}

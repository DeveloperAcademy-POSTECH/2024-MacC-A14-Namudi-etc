//
//  SalaryBudgetRepository.swift
//  Domain
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public protocol SalaryBudgetRepository {
  func create(_ salaryBudget: SalaryBudget) async throws
  
  func readAll() async throws -> [SalaryBudget]
  func readByStartDate(_ startDate: Date) async throws -> SalaryBudget?
  
  func updateTotalFixedIncome(_ id: String, totalFixedIncome: Int) async throws
  func updateFixedExpenses(_ id: String, fixedExpenses: [TransactionItem]) async throws
  func updateBalance(_ id: String, balance: Int) async throws
  func updateDefaultHarubee(_ id: String, defaultHarubee: Double) async throws
  
  func deleteById(_ id: String) async throws
}

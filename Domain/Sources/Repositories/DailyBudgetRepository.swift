//
//  DailyBudgetRepository.swift
//  Domain
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public protocol DailyBudgetRepository {
  func readByDate(_ date: Date) async throws -> DailyBudget?
  
  func updateHarubee(_ id: String, harubee: Int) async throws
  func updateExpense(_ id: String, expense: Int) async throws
  func updateIncome(_ id: String, income: Int) async throws
  func updateMemo(_ id: String, memo: [String]) async throws
}

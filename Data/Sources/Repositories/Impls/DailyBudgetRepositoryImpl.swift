//
//  DailyBudgetRepositoryImpl.swift
//  Data
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftData

public final class DailyBudgetRepositoryImpl: DailyBudgetRepository {
  
  private let modelContext: ModelContext
  
  public init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  public func readByDate(_ date: Date) async throws -> Domain.DailyBudget? {
    print("Impl:", #function)
    return nil
  }
  
  public func updateHarubee(_ id: String, harubee: Int) async throws {
    print("Impl:", #function)
    return
  }
  
  public func updateExpense(_ id: String, expense: Int) async throws {
    print("Impl:", #function)
    return
  }
  
  public func updateIncome(_ id: String, income: Int) async throws {
    print("Impl:", #function)
    return
  }
  
  public func updateMemo(_ id: String, memo: [String]) async throws {
    print("Impl:", #function)
    return
  }
  
  
}

//
//  SettingsRepositoryImpl.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftData

public final class SettingsRepositoryImpl: SettingsRepository {
  
  public init(userDefaults: UserDefaults) {
    
  }
  
  public func saveIncomeDay(_ day: Int) async throws {
    
    return
  }
  
  public func getIncomeDay() async throws -> Int {
    
    return 0
  }
  
  public func saveFixedIncome(_ amount: Int) async throws {
    
    return
  }
  
  public func getFixedIncome() async throws -> Int {
    
    return 0
  }
  
  public func saveFixedExpenses(_ expenses: [Domain.TransactionItem]) async throws {
    
    return
  }
  
  public func getFixedExpenses() async throws -> [Domain.TransactionItem] {
    
    return []
  }
}

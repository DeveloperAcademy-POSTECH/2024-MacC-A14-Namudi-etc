//
//  SettingsUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class SettingsUseCaseImpl: SettingsUseCase {
  
  public init(
    settingsRepository: SettingsRepository
  ) {
    
  }
  
  public func setIncomeDay(_ day: Int) async throws {
    
    return
  }
  
  public func getIncomeDay() async throws -> Int {
    
    return 0
  }
  
  public func setFixedIncome(_ amount: Int) async throws {
    
    return
  }
  
  public func getFixedIncome() async throws -> Int {
    
    return 0
  }
  
  public func addFixedExpense(_ expense: TransactionItem) async throws {
    
    return
  }
  
  public func updateFixedExpense(_ expense: TransactionItem) async throws {
    
    return
  }
  
  public func deleteFixedExpense(_ expense: TransactionItem) async throws {
    
    return
  }
  
  public func getFixedExpenses() async throws -> [TransactionItem] {
    return [TransactionItem.default]
  }
}

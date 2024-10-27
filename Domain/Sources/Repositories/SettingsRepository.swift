//
//  SettingsRepository.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public protocol SettingsRepository {
  /// 고정 수입일 저장
  func saveIncomeDay(_ day: Int) async throws
  
  /// 고정 수입일 조회
  func getIncomeDay() async throws -> Int
  
  /// 고정 수입 금액 저장
  func saveFixedIncome(_ amount: Int) async throws
  
  /// 고정 수입 금액 조회
  func getFixedIncome() async throws -> Int
  
  /// 고정 지출 항목들 저장
  func saveFixedExpenses(_ expenses: [TransactionItem]) async throws
  
  /// 고정 지출 항목들 조회
  func getFixedExpenses() async throws -> [TransactionItem]
}

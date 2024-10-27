//
//  SettingsUseCase.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/27/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

/// 예산 관리에 필요한 기본 설정을 관리하는 UseCase
/// 고정 수입일, 고정 수입 금액, 고정 지출 항목들을 관리합니다.
public protocol SettingsUseCase {
  /// 고정 수입일을 설정합니다.
  /// - Parameter day: 1-31 사이의 일자
  /// - Throws: `DomainError.invalidIncomeDay` if the day is not between 1 and 31
  func setIncomeDay(_ day: Int) async throws
  
  /// 저장된 고정 수입일을 조회합니다.
  /// - Returns: 1-31 사이의 고정 수입일
  /// - Throws: 저장된 고정 수입일이 없을 경우 `DomainError.incomeDataNotFound`
  func getIncomeDay() async throws -> Int
  
  /// 고정 수입 금액을 설정합니다.
  /// - Parameter amount: 0 이상의 금액
  /// - Throws: `DomainError.invalidAmount` if the amount is negative
  func setFixedIncome(_ amount: Int) async throws
  
  /// 저장된 고정 수입 금액을 조회합니다.
  /// - Returns: 고정 수입 금액
  /// - Throws: 저장된 고정 수입 금액이 없을 경우 `DomainError.incomeDataNotFound`
  func getFixedIncome() async throws -> Int
  
  /// 새로운 고정 지출 항목을 추가합니다.
  /// - Parameter expense: 추가할 고정 지출 항목
  /// - Throws: `DomainError.duplicateExpense` if an expense with the same ID already exists
  func addFixedExpense(_ expense: TransactionItem) async throws
  
  /// 기존 고정 지출 항목을 수정합니다.
  /// - Parameter expense: 수정할 고정 지출 항목
  /// - Throws: `DomainError.expenseNotFound` if the expense doesn't exist
  func updateFixedExpense(_ expense: TransactionItem) async throws
  
  /// 기존 고정 지출 항목을 삭제합니다.
  /// - Parameter expense: 삭제할 고정 지출 항목
  /// - Throws: `DomainError.expenseNotFound` if the expense doesn't exist
  func deleteFixedExpense(_ expense: TransactionItem) async throws
  
  /// 모든 고정 지출 항목을 조회합니다.
  /// - Returns: 저장된 모든 고정 지출 항목 배열
  func getFixedExpenses() async throws -> [TransactionItem]
}

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
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 유효하지 않은 일자인 경우
  func setIncomeDay(
    day: Int
  ) throws
  
  /// 저장된 고정 수입일을 조회합니다.
  /// - Returns: 1-31 사이의 고정 수입일
  func getIncomeDay(
  ) throws -> Int
  
  /// 고정 수입 금액을 설정합니다.
  /// - Parameter amount: 10000 이상의 금액
  /// - Throws:
  ///   - `DomainError.invalidAmount`: 금액이 10000 미만인 경우
  ///   - `DomainError.dataNotFound`: SalaryBudget이 없는 경우
  func setFixedIncome(
    amount: Int
  ) throws
  
  /// 저장된 고정 수입 금액을 조회합니다.
  /// - Returns: 고정 수입 금액
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget이 없는 경우
  func getFixedIncome(
  ) throws -> Int
  
  /// 새로운 고정 지출 항목을 추가합니다.
  /// - Parameter expense: 추가할 고정 지출 항목
  /// - Throws:
  ///   - `DomainError.duplicateData`: 동일한 지출 항목이 이미 존재하는 경우
  func addFixedExpense(
    expense: TransactionItem
  ) throws
  
  /// 기존 고정 지출 항목을 수정합니다.
  /// - Parameter expense: 수정할 고정 지출 항목
  /// - Throws:
  ///   - `DomainError.transactionItemNotFound`: 수정할 지출 항목을 찾을 수 없는 경우
  ///   - `DomainError.dataNotFound`: SalaryBudget 또는 기존 항목이 없는 경우
  ///   - `DomainError.duplicateData`: 수정하려는 내용이 이미 존재하는 경우
  func updateFixedExpense(
    expense: TransactionItem
  ) throws
  
  /// 기존 고정 지출 항목을 삭제합니다.
  /// - Parameter expense: 삭제할 고정 지출 항목
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget 또는 삭제할 지출 항목을 찾을 수 없는 경우
  func deleteFixedExpense(
    expense: TransactionItem
  ) throws
  
  /// 모든 고정 지출 항목을 조회합니다.
  /// - Returns: 저장된 모든 고정 지출 항목 배열
  /// - Throws:
  /// - `DomainError.dataNotFound`: SalaryBudget이 없는 경우
  func getFixedExpenses(
  ) throws -> [TransactionItem]
}

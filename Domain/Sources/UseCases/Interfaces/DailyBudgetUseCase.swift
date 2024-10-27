//
//  DailyBudgetUseCase.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/27/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

/// 일별 예산(하루비)을 관리하는 UseCase
/// 하루비 조정, 지출/수입 기록, 메모 관리 등을 담당합니다.
public protocol DailyBudgetUseCase {
  /// 특정 날짜의 하루비를 조정합니다.
  /// - Parameters:
  ///   - amount: 조정할 하루비 금액
  ///   - date: 조정할 날짜
  ///   - salaryBudget: 기록할 SalaryBudget
  /// - Returns: 업데이트된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.invalidAmount`: 금액이 0 미만인 경우
  ///   - `DomainError.insufficientBalance`: 전체 잔액이 부족한 경우
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  func adjustDailyBudget(
    to amount: Int,
    for date: Date,
    in salaryBudget: SalaryBudget
  ) async throws -> SalaryBudget
  
  /// 지출을 기록합니다.
  /// - Parameters:
  ///   - expense: 기록할 지출액
  ///   - date: 지출 날짜
  ///   - salaryBudget: 기록할 SalaryBudget
  /// - Returns: 업데이트된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  func recordExpense(
    to expense: Int,
    for date: Date,
    in salaryBudget: SalaryBudget
  ) async throws -> SalaryBudget
  
  /// 수입을 기록합니다.
  /// - Parameters:
  ///   - income: 기록할 수입액
  ///   - date: 수입 날짜
  ///   - salaryBudget: 기록할 SalaryBudget
  /// - Returns: 업데이트된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  func recordIncome(
    to income: Int,
    for date: Date,
    in salaryBudget: SalaryBudget
  ) async throws -> SalaryBudget
  
  /// 메모를 추가합니다.
  /// - Parameters:
  ///   - memo: 추가할 메모 내용
  ///   - date: 메모를 추가할 날짜
  /// - Returns: 업데이트된 DailyBudget 객체
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  func addMemo(
    to memo: String,
    for date: Date
  ) async throws -> DailyBudget
  
  /// 메모를 삭제합니다.
  /// - Parameters:
  ///   - memo: 삭제할 메모 내용
  ///   - date: 메모를 삭제할 날짜
  /// - Returns: 업데이트된 DailyBudget 객체
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  ///   - `DomainError.memoNotFound`: 해당 메모를 찾을 수 없는 경우
  func deleteMemo(
    to memo: String,
    for date: Date
  ) async throws -> DailyBudget
}

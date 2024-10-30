//
//  DailyBudgetUseCase.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/27/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

/// DailyBudget(일별 예산)을 관리하는 UseCase
/// 조회, 하루비 조정, 지출/수입 기록, 메모 관리 등을 담당합니다.
public protocol DailyBudgetUseCase {
  
  /// 특정 날짜의 DailyBudget을 조회합니다.
  /// - Parameters:
  ///   - date: 조회할 날짜
  /// - Returns: 해당 날짜의 DailyBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 해당 날짜의 DailyBudget을 찾을 수 없는 경우
  func getDailyBudget(
    date: Date
  ) throws -> DailyBudget
  
  /// 특정 날짜의 하루비를 조정합니다.
  /// - Parameters:
  ///   - amount: 조정할 하루비 금액
  ///   - date: 조정할 날짜
  ///   - salaryBudget: 기록할 SalaryBudget
  /// - Returns: 업데이트된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 조정할 DailyBudget을 찾을 수 없는 경우
  func adjustHarubee(
    amount: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
  
  /// 특정 날짜의 하루비를 초기화(nil)합니다.
  /// - Parameters:
  ///   - date: 초기화할 날짜
  ///   - salaryBudget: 기록할 SalaryBudget
  /// - Returns: 업데이트된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  ///   - `DomainError.dataNotFound`: 초기화할 DailyBudget을 찾을 수 없는 경우
  func resetHarubee(
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
  
  /// 지출을 기록합니다.
  /// - Parameters:
  ///   - expense: 기록할 지출액
  ///   - date: 지출 날짜
  ///   - salaryBudget: 기록할 SalaryBudget
  /// - Returns: 업데이트된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 기록할 DailyBudget을 찾을 수 없는 경우
  func recordExpense(
    expense: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
  
  /// 수입을 기록합니다.
  /// - Parameters:
  ///   - income: 기록할 수입액
  ///   - date: 수입 날짜
  ///   - salaryBudget: 기록할 SalaryBudget
  /// - Returns: 업데이트된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 기록할 DailyBudget을 찾을 수 없는 경우
  func recordIncome(
    income: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
  
  /// 메모를 추가합니다.
  /// - Parameters:
  ///   - memo: 추가할 메모 내용
  ///   - date: 메모를 추가할 날짜
  /// - Returns: 업데이트된 DailyBudget 객체
  /// - Throws:
  ///   - `DomainError.duplicateData`: 동일한 내용의 메모가 이미 존재하는 경우
  func addMemo(
    memo: String,
    date: Date
  ) throws -> DailyBudget
  
  /// 메모를 수정합니다.
  /// - Parameters:
  ///   - oldMemo: 수정할 기존 메모 내용
  ///   - newMemo: 새로운 메모 내용
  ///   - date: 메모를 수정할 날짜
  /// - Returns: 업데이트된 DailyBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 수정할 메모를 찾을 수 없는 경우
  ///   - `DomainError.duplicateData`: 수정하려는 내용의 메모가 이미 존재하는 경우
  func updateMemo(
    oldMemo: String,
    newMemo: String,
    date: Date
  ) throws -> DailyBudget
  
  /// 메모를 삭제합니다.
  /// - Parameters:
  ///   - memo: 삭제할 메모 내용
  ///   - date: 메모를 삭제할 날짜
  /// - Returns: 업데이트된 DailyBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 삭제할 메모를 찾을 수 없는 경우
  func deleteMemo(
    memo: String,
    date: Date
  ) throws -> DailyBudget
}

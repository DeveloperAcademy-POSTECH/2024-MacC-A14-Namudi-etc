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
  ///   - date: 하루비를 조정할 DailyBudget
  ///   - salaryBudget: 기본 하루비를 업데이트할 SalaryBudget
  /// - Returns: 업데이트된 DailyBudget, SalaryBudget
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 조정할 DailyBudget을 찾을 수 없는 경우
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  func adjustHarubee(
    amount: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget)
  
  
  /// 지출 및 수입을 기록합니다.
  /// - Parameters:
  ///   - expense: 기록할 지출액
  ///   - income: 기록할 수입액
  ///   - dailyBudget: 지출, 수입을 기록할 DailyBudget
  ///   - salaryBudget: 잔액을 업데이트할 SalaryBudget
  /// - Returns: 업데이트된 DailyBudget, SalaryBudget
  func recordTransaction(
    expense: Int?,
    income: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget)
   
  
  /// 메모 리스트를 업데이트합니다.
  /// - Parameters:
  ///   - memoList: 업데이트할 메모 리스트
  ///   - dailyBudget: 업데이트할 DailyBudget
  /// - Returns: 변경된 DailyBudget
  func updateMemoList(
    memoList: [String],
    dailyBudget: DailyBudget
  ) throws -> DailyBudget
}

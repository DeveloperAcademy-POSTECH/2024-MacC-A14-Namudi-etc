//
//  BudgetCalculationUseCase.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/27/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

/// 예산 계산 관련 기능을 제공하는 UseCase
public protocol BudgetCalculationUseCase {
  /// 기본 하루비를 계산합니다.
  /// - Parameters:
  ///   - balance: 현재 잔액
  ///   - startDate: 계산 시작일
  ///   - endDate: 계산 종료일
  /// - Returns: 계산된 기본 하루비
  /// - Throws:
  ///   - `DomainError.invalidDateRange`: 날짜 범위가 유효하지 않은 경우
  ///   - `DomainError.invalidAmount`: 잔액이 0 미만인 경우
  func calculateDefaultHarubee(
    balance: Int,
    from startDate: Date,
    to endDate: Date
  ) async throws -> Int
  
  /// 평균 하루비를 계산합니다.
  /// - Parameters:
  ///   - salaryBudget: 계산할 예산 기간
  ///   - fromDate: 계산 시작일 (nil인 경우 현재 날짜 사용)
  /// - Returns: 계산된 평균 하루비
  /// - Throws: `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  func calculateAverageHarubee(
    for salaryBudget: SalaryBudget,
    from fromDate: Date?
  ) async throws -> Int
}

//
//  CalculateUseCase.swift
//  Domain
//
//  Created by namdghyun on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public protocol CalculateUseCase {
  
  /// 기본 하루비를 계산합니다.
  /// - Parameters:
  ///   - balance: 현재 잔액
  ///   - startDate: 계산 시작일
  ///   - endDate: 계산 종료일
  ///   - salaryBudget: 조정된 하루비들을 확인하기 위한 SalaryBudget
  /// - Returns: 계산된 기본 하루비
  /// - Throws:
  ///   - `DomainError.invalidDateRange`: 시작일이 종료일보다 늦은 경우
  func calculateDefaultHarubee(
    balance: Int,
    startDate: Date,
    endDate: Date,
    salaryBudget: SalaryBudget
  ) throws -> Double
  
  /// 평균 하루비를 계산합니다.
  /// - Parameters:
  ///   - salaryBudget: 계산할 예산 기간
  ///   - fromDate: 계산 시작일 (nil인 경우 현재 날짜 사용)
  /// - Returns: 계산된 평균 하루비
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 시작일이 예산 기간을 벗어난 경우
  func calculateAverageHarubee(
    salaryBudget: SalaryBudget,
    startDate: Date?
  ) throws -> Double
}

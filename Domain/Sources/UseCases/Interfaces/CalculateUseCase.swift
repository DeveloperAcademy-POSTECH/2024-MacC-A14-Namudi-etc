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
  ///   - salaryBudget: 조정된 하루비들을 확인하기 위한 SalaryBudget
  /// - Returns: 계산된 기본 하루비
  func calculateDefaultHarubee(
    salaryBudget: SalaryBudget
  ) throws -> Double
  
  /// 평균 하루비를 계산합니다.
  /// - Parameters:
  ///   - endDate: 월급 끝 날짜
  ///   - balance: 잔액
  /// - Returns: 계산된 평균 하루비
  func calculateAverageHarubee(
    endDate: Date, balance: Int
  ) throws -> Double
}

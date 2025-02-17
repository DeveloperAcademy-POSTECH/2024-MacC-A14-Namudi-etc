//
//  AdjustHarubeeUseCase.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

protocol AdjustHarubeeUseCase {
  /// 특정 날짜의 하루비를 조정합니다.
  /// - Parameters:
  ///   - amount: 조정할 하루비 금액
  ///   - date: 하루비를 조정할 날짜
  ///   - salaryBudget: 기본 하루비를 업데이트할 SalaryBudget
  /// - Returns: 업데이트된 DailyBudget, SalaryBudget
  func adjustHarubee(
    amount: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget)
}

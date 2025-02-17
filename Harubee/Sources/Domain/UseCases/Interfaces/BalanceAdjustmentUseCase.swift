//
//  BalanceAdjustmentUseCase.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation


protocol BalanceAdjustmentUseCase {
  /// SalaryBudget의 잔액을 업데이트합니다.
  /// - Parameters:
  ///   - salaryBudget: 업데이트할 SalaryBudget
  ///   - newBalance: 새로운 잔액
  func updateBalance(
    salaryBudget: SalaryBudget,
    newBalance: Int
  ) throws -> SalaryBudget
  
  /// 지출 및 수입을 기록하고 잔액을 수정합니다.
  /// - Parameters:
  ///   - expense: 기록할 지출액
  ///   - income: 기록할 수입액
  ///   - date: 지출, 수입을 기록하는 날짜
  ///   - salaryBudget: 잔액을 업데이트할 SalaryBudget
  /// - Returns: 업데이트된 DailyBudget, SalaryBudget
  func recordTransaction(
    expense: Int?,
    income: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget)
}

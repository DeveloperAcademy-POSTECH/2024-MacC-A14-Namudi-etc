//
//  FixedTransactionManagementUseCase.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

protocol FixedTransactionManagementUseCase {
  /// 고정 수입 금액을 설정합니다.
  /// - Parameters:
  ///   - salaryBudget: 업데이트할 SalaryBudget
  ///   - newIncome: 10000 이상의 금액
  /// - Returns: 업데이트된 SalaryBudget
  func updateFixedIncome(
    salaryBudget: SalaryBudget,
    newIncome: Int
  ) throws -> SalaryBudget
  
  
  /// 모든 지출 항목을 수정합니다.
  /// - Parameters:
  ///   - salaryBudget: 업데이트할 SalaryBudget
  ///   - expenses: 수정할 모든 고정 지출 항목
  /// - Returns: 업데이트된 SalaryBudget
  func updateFixedExpenses(
    salaryBudget: SalaryBudget,
    expenses: [TransactionItem]
  ) throws -> SalaryBudget
  
  /// 고정 수입일을 수정합니다.
  /// - Parameter day: 1-31 사이의 일자
  /// - Returns: 업데이트된 SalaryBudget
  func updateIncomeDay(
    day: Int,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
  
  /// 저장된 고정 수입일을 조회합니다.
  /// - Returns: 1-31 사이의 고정 수입일
  func getIncomeDay() -> Int?
}

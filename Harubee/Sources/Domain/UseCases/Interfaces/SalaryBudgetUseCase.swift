//
//  SalaryBudgetUseCase.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

protocol SalaryBudgetUseCase {
  /// 모든 SalaryBudget을 가져옵니다.
  /// - Returns: 저장된 모든 SalaryBudget
  func fetchAll() throws -> [SalaryBudget]
  
  /// 이번 기간에 해당하는 SalaryBudget을 가져옵니다.
  /// 이 과정에서 이번 기간 또는 다음 기간의 SalaryBudget이 존재하지 않을 경우 자동으로 생성합니다.
  /// - Returns: 이번 기간의 SalaryBudget
  func fetchCurrent() throws -> SalaryBudget
  
  /// 특정 날짜가 포함된 SalaryBudget을 조회합니다.
  /// - Parameter date: 조회할 날짜(nil인 경우 현재 날짜)
  /// - Returns: 해당 날짜가 포함된 SalaryBudget 객체
  func fetch(date: Date) throws -> SalaryBudget
  
  /// 저장된 모든 SalaryBudget을 삭제합니다
  func deleteAll() throws
}

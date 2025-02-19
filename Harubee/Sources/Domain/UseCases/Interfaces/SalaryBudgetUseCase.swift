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
  
  /// 특정 날짜가 포함된 SalaryBudget을 조회합니다.
  /// - Parameter date: 조회할 날짜(nil인 경우 현재 날짜)
  /// - Returns: 해당 날짜가 포함된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget을 찾을 수 없는 경우
  func fetchCurrent(date: Date?) throws -> SalaryBudget
  
  /// 저장된 모든 SalaryBudget을 삭제합니다
  func deleteAll() throws
}

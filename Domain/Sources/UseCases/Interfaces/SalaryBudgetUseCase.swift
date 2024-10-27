//
//  BudgetPeriodUseCase.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/27/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

/// SalaryBudget을 관리하는 UseCase
/// 새로운 SalaryBudget 생성, 기존 SalaryBudget 조회 및 관리를 담당합니다.
public protocol SalaryBudgetUseCase {
  /// 새로운 SalaryBudget을 생성합니다.
  /// - Parameters:
  ///   - startDate: SalaryBudget 시작일
  ///   - endDate: SalaryBudget 종료일
  ///   - fixedIncome: 고정 수입 금액
  ///   - fixedExpenses: 고정 지출 항목 배열
  /// - Returns: 생성된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.invalidDateRange`: 시작일이 종료일보다 늦은 경우
  ///   - `DomainError.overlappingSalaryBudget`: 기존 SalaryBudget과 겹치는 경우
  func createSalaryBudget(
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) async throws -> SalaryBudget
  
  /// 현재 날짜가 포함된 SalaryBudget을 조회합니다.
  /// - Returns: 현재 활성화된 SalaryBudget 객체 (없으면 nil)
  func getCurrentSalaryBudget() async throws -> SalaryBudget?
  
  /// 특정 날짜가 포함된 SalaryBudget을 조회합니다.
  /// - Parameter date: 조회할 날짜
  /// - Returns: 해당 날짜가 포함된 SalaryBudget 객체 (없으면 nil)
  func getSalaryBudget(for date: Date) async throws -> SalaryBudget?
  
  /// SalaryBudget의 잔액을 업데이트합니다.
  /// - Parameters:
  ///   - budgetPeriod: 업데이트할 SalaryBudget
  ///   - newBalance: 새로운 잔액
  /// - Throws: `DomainError.SalaryBudgetNotFound`: SalaryBudget을 찾을 수 없는 경우
  func updateBalance(
    for budgetPeriod: SalaryBudget,
    newBalance: Int
  ) async throws
}

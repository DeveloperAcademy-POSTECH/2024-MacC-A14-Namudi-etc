//
//  BudgetPeriodUseCase.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/27/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

/// SalaryBudget(월급 기간별 예산)을 관리하는 UseCase
/// 새로운 SalaryBudget 생성, 기존 SalaryBudget 조회 및 관리를 담당합니다.
public protocol SalaryBudgetUseCase {
  
  /// 새로운 SalaryBudget을 생성합니다.
  /// - Parameters:
  ///   - startDate: SalaryBudget 시작일
  ///   - endDate: SalaryBudget 종료일
  ///   - previousExpense: 온보딩 시 이전 지출 금액
  ///   - fixedIncome: 고정 수입 금액
  ///   - fixedExpenses: 고정 지출 항목 배열
  /// - Returns: 생성된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.duplicateData`: 동일한 기간의 SalaryBudget이 존재하는 경우
  func createSalaryBudget(
    startDate: Date,
    endDate: Date,
    previousExpense: Int?,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget
  
  
  /// 모든 SalaryBudget을 가져옵니다.
  /// - Returns: 저장된 모든 SalaryBudget
  func getAllSalaryBudget() throws -> [SalaryBudget]
  
  /// 특정 날짜가 포함된 SalaryBudget을 조회합니다.
  /// - Parameter date: 조회할 날짜(nil인 경우 현재 날짜)
  /// - Returns: 해당 날짜가 포함된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget을 찾을 수 없는 경우
  func getSalaryBudget(
    date: Date?
  ) throws -> SalaryBudget
  
  /// SalaryBudget의 잔액을 업데이트합니다.
  /// - Parameters:
  ///   - salaryBudget: 업데이트할 SalaryBudget
  ///   - newBalance: 새로운 잔액
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget을 찾을 수 없는 경우
  func updateBalance(
    salaryBudget: SalaryBudget,
    newBalance: Int
  ) throws -> SalaryBudget
  
  
  
  /// 기본 하루비를 계산하여 SalaryBudget에 반영합니다
  /// - Parameter salaryBudget: 기본 하루비를 다시 계산할 SalaryBudget
  /// - Returns: 변경된 SalaryBudget
  func updateDefaultHarubee(
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
}

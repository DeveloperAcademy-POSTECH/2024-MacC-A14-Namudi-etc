//
//  BudgetRepository.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public protocol BudgetRepository {
  /// 새로운 SalaryBudget을 저장
  func saveSalaryBudget(_ salaryBudget: SalaryBudget) async throws
  
  /// 특정 날짜가 포함된 SalaryBudget 조회
  func getSalaryBudget(containing date: Date) async throws -> SalaryBudget?
  
  /// 모든 SalaryBudget 조회
  func getAllSalaryBudgets() async throws -> [SalaryBudget]
  
  /// 일별 예산 저장
  func saveDailyBudget(_ dailyBudget: DailyBudget, for date: Date) async throws
  
  /// 특정 날짜의 일별 예산 조회
  func getDailyBudget(for date: Date) async throws -> DailyBudget?
  
  /// 기간 내의 모든 일별 예산 조회
  func getDailyBudgets(from startDate: Date, to endDate: Date) async throws -> [DailyBudget]
}

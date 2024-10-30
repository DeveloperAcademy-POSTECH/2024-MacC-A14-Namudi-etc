//
//  SalaryBudgetRepository.swift
//  Domain
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public protocol SalaryBudgetRepository {
  
  /// SalaryBudget을 DB에 저장합니다.
  /// - Parameter salaryBudget: 저장할 SalaryBudget
  func create(_ salaryBudget: SalaryBudget)
  
  
  /// DB에 저장된 모든 SalaryBudget을 불러옵니다.
  /// - Returns: DB에 저장된 모든 SalaryBudget
  func readAll() throws -> [SalaryBudget]
  
  /// DB에서 특정 날짜에 해당하는 SalaryBudget을 가져옵니다.
  /// - Parameter startDate: 시작 날짜
  /// - Returns: Optional(시작 날짜에 해당하는 SalaryBudget)
  func readByStartDate(_ startDate: Date) throws -> SalaryBudget?
  
  
  /// 변경하고싶은 SalaryBudget의 프로퍼티를 변경합니다
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - fixedIncome: 변경할 고정 수입 금액
  ///   - fixedExpenses: 변경할 고정 지출 내역
  ///   - balance: 변경할 잔액
  ///   - defaultHarubee: 변경할 기본 하루비 금액
  func updateSalaryBudget(
    _ id: String,
    fixedIncome: UpdateValue<Int>,
    fixedExpenses: UpdateValue<[TransactionItem]>,
    balance: UpdateValue<Int>,
    defaultHarubee: UpdateValue<Double>
  ) throws
  
  /// 총 고정 수입 금액을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - totalFixedIncome: 변경할 고정 수입 금액
  func updateFixedIncome(_ id: String, fixedIncome: Int) throws
  
  /// 고정 지출 내역을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - fixedExpenses: 변경할 고정 지출 내역
  func updateFixedExpenses(_ id: String, fixedExpenses: [TransactionItem]) throws
  
  /// 잔액을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - balance: 변경할 잔액
  func updateBalance(_ id: String, balance: Int) throws
  
  /// 기본 하루비를 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - defaultHarubee: 변경할 기본 하루비 금액
  func updateDefaultHarubee(_ id: String, defaultHarubee: Double) throws
  
  
  /// DB에서 SalaryBudget을 삭제합니다.
  /// - Parameter id: 삭제할 SalaryBudget의 ID
  func deleteById(_ id: String) throws
}

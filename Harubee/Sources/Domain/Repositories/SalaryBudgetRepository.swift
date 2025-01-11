//
//  SalaryBudgetRepository.swift
//  Domain
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

protocol SalaryBudgetRepository {
  
  /// SalaryBudget을 DB에 저장합니다.
  /// - Parameter salaryBudget: 저장할 SalaryBudget
  func create(_ salaryBudget: SalaryBudget)
  
  
  /// DB에 저장된 모든 SalaryBudget을 불러옵니다.
  /// - Returns: DB에 저장된 모든 SalaryBudget
  func readAll() throws -> [SalaryBudget]
  
  /// DB에 저장된 모든 SalaryBudget들 중 특정 날짜 이후에 해당하는 것들을 가져옵니다.
  /// - Parameter date: 타겟 날짜
  /// - Returns: 타겟 날짜 이후에 해당되는 모든 SalaryBudget
  func readAll(after date: Date) throws -> [SalaryBudget]
  
  /// DB에서 특정 날짜가 포함되어있는 SalaryBudget을 가져옵니다.
  /// - Parameter targetDate: 타겟 날짜
  /// - Returns: Optional(타겟 날짜를 포함하는 SalaryBudget)
  func readByTargetDateContaining(_ targetDate: Date) throws -> SalaryBudget?
  
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
  /// - Returns: 변경된 SalaryBudget
  @discardableResult
  func updateSalaryBudget(
    _ id: String,
    fixedIncome: UpdateValue<Int>,
    fixedExpenses: UpdateValue<[TransactionItem]>,
    balance: UpdateValue<Int>,
    defaultHarubee: UpdateValue<Double>
  ) throws -> SalaryBudget
  
  /// 총 고정 수입 금액을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - totalFixedIncome: 변경할 고정 수입 금액
  /// - Returns: 변경된 SalaryBudget
  @discardableResult
  func updateFixedIncome(_ id: String, fixedIncome: Int) throws -> SalaryBudget
  
  /// 고정 지출 내역을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - fixedExpenses: 변경할 고정 지출 내역
  /// - Returns: 변경된 SalaryBudget
  @discardableResult
  func updateFixedExpenses(
    _ id: String,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget
  
  /// 잔액을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - balance: 변경할 잔액
  /// - Returns: 변경된 SalaryBudget
  @discardableResult
  func updateBalance(_ id: String, balance: Int) throws -> SalaryBudget
  
  /// 기본 하루비를 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 SalaryBudget의 ID
  ///   - defaultHarubee: 변경할 기본 하루비 금액
  /// - Returns: 변경된 SalaryBudget
  @discardableResult
  func updateDefaultHarubee(_ id: String, defaultHarubee: Double) throws -> SalaryBudget
  
  
  /// 저장된 모든 SalaryBudget을 삭제합니다.
  func deleteAll() throws
  
  /// DB에서 SalaryBudget을 삭제합니다.
  /// - Parameter id: 삭제할 SalaryBudget의 ID
  func deleteById(_ id: String) throws
}

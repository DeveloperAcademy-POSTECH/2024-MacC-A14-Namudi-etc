//
//  DailyBudgetRepository.swift
//  Domain
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public protocol DailyBudgetRepository {
  
  /// DB에서 특정 날짜에 해당하는 DailyBudget을 가져옵니다.
  /// - Parameter date: 날짜
  /// - Returns: Optional(해당 날짜와 일치하느
  func readByDate(_ date: Date) throws -> DailyBudget?
  
  /// 하루비를 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 DailyBudget의 ID
  ///   - harubee: 변경할 하루비 금액
  func updateHarubee(_ id: String, harubee: Int) throws
  
  /// 지출 금액을 변경합니다
  /// - Parameters:
  ///   - id: 변경할 DailyBudget의 ID
  ///   - expense: 변경할 지출 금액
  func updateExpense(_ id: String, expense: Int) throws
  
  /// 수입 금액을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 DailyBudget의 ID
  ///   - income: 변경할 수입 금액
  func updateIncome(_ id: String, income: Int) throws
  
  /// 메모 내역을 변경합니다.
  /// - Parameters:
  ///   - id: 변경할 DailyBudget의 ID
  ///   - memo: 변경할 메모 내역
  func updateMemo(_ id: String, memo: [String]) throws
}

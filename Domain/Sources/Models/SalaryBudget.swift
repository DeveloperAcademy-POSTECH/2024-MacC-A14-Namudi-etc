//
//  SalaryBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct SalaryBudget: Identifiable {
  public let id: UUID
  public let startDate: Date
  public let endDate: Date
  public let fixedIncome: Int
  public let fixedExpense: [TransactionItem]
  public var balance: Int
  public var defaultHarubee: Int
  public var dailyBudgets: [DailyBudget]
  
  static var `default`: SalaryBudget {
    .init(
      id: .init(),
      startDate: .init(),
      endDate: .init(),
      fixedIncome: 0,
      fixedExpense: [],
      balance: 0,
      defaultHarubee: 0,
      dailyBudgets: []
    )
  }
}

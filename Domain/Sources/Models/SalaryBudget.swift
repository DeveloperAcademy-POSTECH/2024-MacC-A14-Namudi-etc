//
//  SalaryBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct SalaryBudget: Identifiable {
  public let id: String = UUID().uuidString
  public let startDate: Date
  public let endDate: Date
  public var fixedIncome: Int
  public var fixedExpense: [TransactionItem]
  public var balance: Int
  public var defaultHarubee: Double
  public var dailyBudgets: [DailyBudget]
  
  static var `default`: SalaryBudget {
    .init(
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

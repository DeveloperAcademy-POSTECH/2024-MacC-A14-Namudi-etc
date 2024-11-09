//
//  SalaryBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct SalaryBudget: Identifiable {
  public let id: String
  public let startDate: Date
  public let endDate: Date
  public var fixedIncome: Int
  public var fixedExpenses: [TransactionItem]
  public var balance: Int
  public var defaultHarubee: Double
  public var dailyBudgets: [DailyBudget]
  
  public init(
    id: String = UUID().uuidString,
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem],
    balance: Int,
    defaultHarubee: Double,
    dailyBudgets: [DailyBudget]
  ) {
    self.id = id
    self.startDate = startDate
    self.endDate = endDate
    self.fixedIncome = fixedIncome
    self.fixedExpenses = fixedExpenses
    self.balance = balance
    self.defaultHarubee = defaultHarubee
    self.dailyBudgets = dailyBudgets
  }
  
  public static var `default`: SalaryBudget {
    .init(
      startDate: .init(),
      endDate: .init(),
      fixedIncome: 0,
      fixedExpenses: [],
      balance: 0,
      defaultHarubee: 100000,
      dailyBudgets: []
    )
  }
}

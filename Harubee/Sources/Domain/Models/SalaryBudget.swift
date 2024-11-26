//
//  SalaryBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct SalaryBudget: Identifiable {
  let id: String
  let startDate: Date
  let endDate: Date
  var fixedIncome: Int
  var fixedExpenses: [TransactionItem]
  var balance: Int
  var defaultHarubee: Double
  var dailyBudgets: [DailyBudget]
  
  init(
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
  
  static var `default`: SalaryBudget {
    .init(
      startDate: .init(),
      endDate: .init(),
      fixedIncome: 0,
      fixedExpenses: [],
      balance: 0,
      defaultHarubee: 20000,
      dailyBudgets: [
        .init(
          date: .now.formattedDate,
          harubee: 25000,
          memo: []
        ),
        .init(
          date: .now.formattedDate.addingTimeInterval(TimeInterval(86400 * 1)),
          harubee: nil,
          memo: []
        ),
        .init(
          date: .now.formattedDate.addingTimeInterval(TimeInterval(86400 * 2)),
          harubee: nil,
          memo: []
        ),
        .init(
          date: .now.formattedDate.addingTimeInterval(TimeInterval(86400 * 3)),
          harubee: nil,
          memo: []
        ),
        .init(
          date: .now.formattedDate.addingTimeInterval(TimeInterval(86400 * 4)),
          harubee: nil,
          memo: []
        ),
        .init(
          date: .now.formattedDate.addingTimeInterval(TimeInterval(86400 * 5)),
          harubee: nil,
          memo: []
        ),
      ]
    )
  }
}

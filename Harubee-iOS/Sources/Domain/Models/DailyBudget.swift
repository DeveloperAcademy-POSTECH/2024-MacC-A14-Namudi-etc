//
//  DailyBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct DailyBudget: Identifiable {
  let id: String
  let date: Date
  var harubee: Int?
  var memo: [String]
  var expense: Int?
  var income: Int?
  
  init(
    id: String = UUID().uuidString,
    date: Date,
    harubee: Int? = nil,
    memo: [String],
    expense: Int? = nil,
    income: Int? = nil
  ) {
    self.id = id
    self.date = date
    self.harubee = harubee
    self.memo = memo
    self.expense = expense
    self.income = income
  }
  
  static var `default`: DailyBudget {
    .init(
      date: .init(),
      harubee: nil,
      memo: [],
      expense: nil,
      income: nil
    )
  }
}

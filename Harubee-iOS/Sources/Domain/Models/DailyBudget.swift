//
//  DailyBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct DailyBudget: Identifiable {
  public let id: String
  public let date: Date
  public var harubee: Int?
  public var memo: [String]
  public var expense: Int?
  public var income: Int?
  
  public init(
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
  
  public static var `default`: DailyBudget {
    .init(
      date: .init(),
      harubee: nil,
      memo: [],
      expense: nil,
      income: nil
    )
  }
}

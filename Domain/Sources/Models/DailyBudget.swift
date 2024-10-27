//
//  DailyBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct DailyBudget: Identifiable {
  public let id: UUID
  public let date: Date
  public var harubee: Int?
  public var memo: [String]
  public var expense: Int?
  public var income: Int?
  
  static var `default`: DailyBudget {
    .init(
      id: .init(),
      date: .init(),
      harubee: nil,
      memo: [],
      expense: nil,
      income: nil
    )
  }
}

//
//  DailyStreak.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/24/24.
//

import Foundation

// MARK: - DailyStreak
struct DailyStreak: Hashable {
  enum Time {
    case today
    case future
  }
  
  enum ExpenseType {
    case empty
    case good
    case bad
  }
  
  let date: Date
  let time: Time
  let harubee: Int
  let isAdjustedHarubee: Bool
  let expenseType: ExpenseType
  
  init(
    date: Date,
    time: Time,
    harubee: Int,
    isAdjustedHarubee: Bool = false,
    expenseType: ExpenseType = .empty
  ) {
    self.date = date
    self.time = time
    self.harubee = harubee
    self.isAdjustedHarubee = isAdjustedHarubee
    self.expenseType = expenseType
  }
  
  static let mock: [Self] = [
    .init(
      date: .now,
      time: .today,
      harubee: 130000,
      expenseType: .empty
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 1),
      time: .future,
      harubee: 99999,
      isAdjustedHarubee: true
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 2),
      time: .future,
      harubee: 999999
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 3),
      time: .future,
      harubee: 100000
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 4),
      time: .future,
      harubee: 100000
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 5),
      time: .future,
      harubee: 100000
    )
  ]
}

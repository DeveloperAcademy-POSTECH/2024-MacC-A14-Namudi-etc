//
//  DailyStreak.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/24/24.
//

import Foundation

// MARK: - DailyStreak
struct DailyStreak: Hashable {
  static let count = 6
  
  enum Time {
    case today
    case future
  }
  
  enum ExpenseType {
    case empty
    case good
    case bad
  }
  
  let date: Date?
  let time: Time
  let harubee: Int?
  let isAdjustedHarubee: Bool
  let expenseType: ExpenseType
  
  init(
    date: Date?,
    time: Time,
    harubee: Int?,
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
      date: .now.formattedDate,
      time: .today,
      harubee: 13000,
      expenseType: .empty
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 1).formattedDate,
      time: .future,
      harubee: 20000,
      isAdjustedHarubee: true
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 2).formattedDate,
      time: .future,
      harubee: 20000
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 3).formattedDate,
      time: .future,
      harubee: 20000
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 4).formattedDate,
      time: .future,
      harubee: 23000
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 5).formattedDate,
      time: .future,
      harubee: 18000,
      isAdjustedHarubee: true
    ),
  ]
}

//
//  SalaryBudget.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct SalaryBudget: Identifiable, Hashable {
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

extension SalaryBudget {
  static func create(
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) -> SalaryBudget {
    // 1. 시작, 종료까지의 일자 구하기
    let days = startDate.daysUntil(endDate)
    
    // 2. 고정 수입에서 총 고정 지출 금액 뺀 잔액 구하기
    let totalFixedExpenses = fixedExpenses
      .reduce(0) { $0 + $1.price }
    let balance = fixedIncome - totalFixedExpenses
    
    // 3. 기본 하루비 구하기
    let defaultHarubee = Double(balance) / Double(days + 1)
    
    // 4. DailyBudgets 생성
    let dailyBudgets = (0...days).compactMap { day -> DailyBudget? in
      guard let date = startDate.adding(
        by: .day, value: day
      ) else { return nil }
      
      return DailyBudget(
        date: date,
        harubee: nil,
        memo: [],
        expense: nil,
        income: nil
      )
    }
    
    // 5. SalaryBudget 리턴
    return SalaryBudget(
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncome,
      fixedExpenses: fixedExpenses,
      balance: balance,
      defaultHarubee: defaultHarubee,
      dailyBudgets: dailyBudgets
    )
  }
}

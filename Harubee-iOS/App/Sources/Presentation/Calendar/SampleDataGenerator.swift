//
//  SampleDataGenerator.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

extension Date {
  static func createDate(year: Int, month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = 0
    components.minute = 0
    components.second = 0
    
    return Calendar.current.date(from: components) ?? Date().formattedDate
  }
}

enum SampleError: LocalizedError {
  case testError
}


class SampleDataGenerator {
  static func createSampleSalaryBudget(withError: Bool) throws -> SalaryBudget  {
    if withError {
      throw SampleError.testError
    }
    
    // Create sample dates for a month period
    let startDate = Date.createDate(year: 2024, month: 10, day: 20)
    let endDate = Date.createDate(year: 2024, month: 11, day: 19)
    
    // Sample fixed expenses
    let fixedExpenses = [
      TransactionItem(
        date: startDate,
        name: "월세",
        price: 500000
      ),
      TransactionItem(
        date: Date.createDate(year: 2024, month: 10, day: 28),
        name: "통신비",
        price: 50000
      ),
      TransactionItem(
        date: Date.createDate(year: 2024, month: 10, day: 30),
        name: "구독서비스",
        price: 30000
      )
    ]
    
    // Create daily budgets for the entire period
    var dailyBudgets: [DailyBudget] = []
    let calendar = Calendar.current
    var currentDate = startDate
    
    while currentDate <= endDate {
      // Create some variety in the data
      let isWeekend = calendar.isDateInWeekend(currentDate)
      let randomExpense = isWeekend ? Int.random(in: 20000...40000) : Int.random(in: 10000...25000)
      let shouldHaveExpense = Bool.random()
      let shouldAdjustHarubee = Bool.random()
      
      let dailyBudget = DailyBudget(
        date: currentDate,
        harubee: shouldAdjustHarubee ? Int.random(in: 20000...30000) : nil,
        memo: ["샘플 메모 \(calendar.component(.day, from: currentDate))일차"],
        expense: shouldHaveExpense ? randomExpense : nil,
        income: Bool.random() ? Int.random(in: 10000...50000) : nil
      )
      
      dailyBudgets.append(dailyBudget)
      
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
    }
    
    // Calculate total fixed expenses
    let totalFixedExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    
    return SalaryBudget(
      id: UUID().uuidString,
      startDate: startDate,
      endDate: endDate,
      fixedIncome: 3000000, // 월급 300만원
      fixedExpenses: fixedExpenses,
      balance: 3000000 - totalFixedExpenses, // 월급에서 고정지출 제외
      defaultHarubee: 25000.0, // 기본 하루비 2.5만원
      dailyBudgets: dailyBudgets
    )
  }
  
  // 여러 개의 샘플 데이터가 필요한 경우를 위한 헬퍼 메서드
  static func createMultipleSampleBudgets() throws -> [SalaryBudget] {
    let currentBudget = try createSampleSalaryBudget(withError: false)
    
    // 이전 달의 예산 생성
    var components = DateComponents()
    components.month = -1
    let calendar = Calendar.current
    
    let previousStartDate = calendar.date(byAdding: components, to: currentBudget.startDate)!
    let previousEndDate = calendar.date(byAdding: components, to: currentBudget.endDate)!
    
    let previousFixedExpenses = [
      TransactionItem(
        date: previousStartDate,
        name: "월세",
        price: 500000
      ),
      TransactionItem(
        date: calendar.date(byAdding: .day, value: 3, to: previousStartDate)!,
        name: "통신비",
        price: 50000
      ),
      TransactionItem(
        date: calendar.date(byAdding: .day, value: 5, to: previousStartDate)!,
        name: "구독서비스",
        price: 30000
      )
    ]
    
    var previousDailyBudgets: [DailyBudget] = []
    var currentDate = previousStartDate
    
    while currentDate <= previousEndDate {
      let isWeekend = calendar.isDateInWeekend(currentDate)
      let randomExpense = isWeekend ? Int.random(in: 20000...40000) : Int.random(in: 10000...25000)
      
      let dailyBudget = DailyBudget(
        date: currentDate,
        harubee: Bool.random() ? Int.random(in: 20000...30000) : nil,
        memo: ["이전 달 샘플 메모 \(calendar.component(.day, from: currentDate))일차"],
        expense: Bool.random() ? randomExpense : nil,
        income: Bool.random() ? Int.random(in: 10000...50000) : nil
      )
      
      previousDailyBudgets.append(dailyBudget)
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
    }
    
    let previousBudget = SalaryBudget(
      id: UUID().uuidString,
      startDate: previousStartDate,
      endDate: previousEndDate,
      fixedIncome: 3000000,
      fixedExpenses: previousFixedExpenses,
      balance: 3000000 - previousFixedExpenses.reduce(0) { $0 + $1.price },
      defaultHarubee: 25000.0,
      dailyBudgets: previousDailyBudgets
    )
    
    return [previousBudget, currentBudget]
  }
}

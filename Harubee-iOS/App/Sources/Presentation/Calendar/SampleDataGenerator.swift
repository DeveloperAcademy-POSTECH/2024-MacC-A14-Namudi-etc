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

  static func createMultipleSampleBudgets() throws -> [SalaryBudget] {
    let calendar = Calendar.current
    var allBudgets: [SalaryBudget] = []
    
    // 현재 예산을 기준으로 생성
    let currentBudget = try createSampleSalaryBudget(withError: false)
    let monthDuration = calendar.dateComponents([.day], from: currentBudget.startDate, to: currentBudget.endDate).day ?? 30
    
    // 1000개의 과거 예산과 999개의 미래 예산, 그리고 현재 예산 1개 (총 500개)
    for offset in -1000...999 {
      var components = DateComponents()
      components.month = offset
      
      guard let startDate = calendar.date(byAdding: components, to: currentBudget.startDate),
            let endDate = calendar.date(byAdding: .day, value: monthDuration, to: startDate) else {
        continue
      }
      
      // 해당 기간의 고정 지출 생성
      let fixedExpenses = [
        TransactionItem(
          date: startDate,
          name: "월세",
          price: 500000
        ),
        TransactionItem(
          date: calendar.date(byAdding: .day, value: 3, to: startDate)!,
          name: "통신비",
          price: 50000
        ),
        TransactionItem(
          date: calendar.date(byAdding: .day, value: 5, to: startDate)!,
          name: "구독서비스",
          price: 30000
        )
      ]
      
      // 해당 기간의 일별 예산 생성
      var dailyBudgets: [DailyBudget] = []
      var currentDate = startDate
      
      while currentDate <= endDate {
        let isWeekend = calendar.isDateInWeekend(currentDate)
        let randomExpense = isWeekend ? Int.random(in: 20000...40000) : Int.random(in: 10000...25000)
        
        // 과거 날짜는 지출이 있을 확률을 높이고, 미래 날짜는 지출이 없게 설정
        let shouldHaveExpense = currentDate <= Date() ? Double.random(in: 0...1) > 0.2 : false
        
        let dailyBudget = DailyBudget(
          date: currentDate,
          harubee: Bool.random() ? Int.random(in: 20000...30000) : nil,
          memo: ["샘플 메모 \(calendar.component(.day, from: currentDate))일차 (기간: \(offset))"],
          expense: shouldHaveExpense ? randomExpense : nil,
          income: Bool.random() ? Int.random(in: 10000...50000) : nil
        )
        
        dailyBudgets.append(dailyBudget)
        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
      }
      
      // SalaryBudget 생성
      let budget = SalaryBudget(
        id: UUID().uuidString,
        startDate: startDate,
        endDate: endDate,
        fixedIncome: 3000000,
        fixedExpenses: fixedExpenses,
        balance: 3000000 - fixedExpenses.reduce(0) { $0 + $1.price },
        defaultHarubee: 25000.0,
        dailyBudgets: dailyBudgets
      )
      
      allBudgets.append(budget)
    }
    
    // 날짜순으로 정렬
    return allBudgets.sorted { $0.startDate < $1.startDate }
  }
}

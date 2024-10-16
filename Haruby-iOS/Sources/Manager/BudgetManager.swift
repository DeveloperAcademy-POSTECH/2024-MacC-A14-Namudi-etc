//
//  BudgetManager.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/17/24.
//

import Foundation

final class BudgetManager {
    
    private init() {}
    
    /// 급여일과 날짜를 가지고 startDate를 계산하는 함수
    static func calculateStartDate(from currentDate: Date, incomeDate: Int) -> Date {
        let calendar = Calendar.current
        var startDate = currentDate
        
        // incomeDate와 일치하는 날짜를 찾을 때까지 하루씩 뒤로 이동
        while true {
            let components = calendar.dateComponents([.day], from: startDate)
            if components.day == incomeDate { break }
            startDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
        }
        
        return startDate.formattedDate
    }
    
    /// 급여일을 가지고 예산의 기간을 계산하는 함수
    static func calculateBudgetPeriod(incomeDate: Int) -> (startDate: Date, endDate: Date) {
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: today)
        
        if incomeDate <= components.day! {
            // 케이스 1: 급여일이 오늘이거나 이번 달에 이미 지났을 경우
            let startDate = calendar.date(from: DateComponents(year: components.year, month: components.month, day: incomeDate))!
            let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
            return (startDate, endDate)
        } else {
            // 케이스 2: 급여일이 이번 달 미래인 경우
            let lastMonthIncomeDate = calendar.date(byAdding: .month, value: -1, to: calendar.date(from: DateComponents(year: components.year, month: components.month, day: incomeDate))!)!.formattedDate
            let endDate = calendar.date(byAdding: .day, value: -1, to: calendar.date(from: DateComponents(year: components.year, month: components.month, day: incomeDate))!)!.formattedDate
            return (lastMonthIncomeDate, endDate)
        }
    }
    
    /// startDate와 endDate로 salaryBudget을 생성해 반환하는 함수
    static func createSalaryBudget(startDate: Date, endDate: Date) -> SalaryBudget {
        let dailyBudgets = createDailyBudgets(from: startDate, to: endDate)
        return SalaryBudget(startDate: startDate,
                            endDate: endDate,
                            fixedIncome: 0,
                            fixedExpense: [],
                            balance: 0,
                            defaultHaruby: 0,
                            dailyBudgets: dailyBudgets)
    }
    
    static private func createDailyBudgets(from startDate: Date, to endDate: Date) -> [DailyBudget] {
        var dailyBudgets: [DailyBudget] = []
        var currentDate = startDate
        while currentDate <= endDate {
            let dailyBudget = DailyBudget(date: currentDate,
                                          haruby: nil,
                                          memo: "",
                                          expense: TransactionRecord(total: 0, transactionItems: []),
                                          income: TransactionRecord(total: 0, transactionItems: []))
            dailyBudgets.append(dailyBudget)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dailyBudgets
    }

}

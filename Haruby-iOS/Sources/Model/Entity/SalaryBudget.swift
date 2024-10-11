//
//  SalaryBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

struct SalaryBudget {
    var id: UUID = UUID()
    var startDate: Date
    var endDate: Date
    var fixedIncome: Int
    var fixedExpense: [ExpenseItem]
    var balance: Int
    var defaultHaruby: Int
    var dailyBudgets: [DailyBudget]
}

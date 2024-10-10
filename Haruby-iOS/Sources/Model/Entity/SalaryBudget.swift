//
//  SalaryBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

struct SalaryBudget {
    var startDate: String
    var endDate: String
    var fixedIncome: Int
    var fixedExpense: [ExpenseItem]
    var balance: Int
    var defaultHaruby: Int
    var dailyBudgets: [DailyBudget]
}

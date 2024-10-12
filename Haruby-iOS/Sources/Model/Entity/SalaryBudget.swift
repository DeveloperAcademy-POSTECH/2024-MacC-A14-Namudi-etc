//
//  SalaryBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

struct SalaryBudget {
    var id: String = UUID().uuidString
    var startDate: Date
    var endDate: Date
    var fixedIncome: Int
    var fixedExpense: [TransactionItem]
    var balance: Int
    var defaultHaruby: Int
    var dailyBudgets: [DailyBudget]
}

//
//  RealmSalaryBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmSalaryBudget: Object {
    
    // 고민할 부분 :
    // 앱 내에서 start, end를 사용할 때 Date 타입으로 사용할거면 Date로 저장하고
    // Primary ID 값을 추가해주는 것이 어떨까
    @Persisted(primaryKey: true) var startDate: String
    @Persisted var endDate: String
    @Persisted var fixedIncome: Int
    @Persisted var fixedExpense: List<RealmExpenseItem>
    @Persisted var balance: Int
    @Persisted var defaultHaruby: Int
    @Persisted var dailyBudgets: List<RealmDailyBudget>
    
    convenience init(
        startDate: String,
        endDate: String,
        fixedIncome: Int,
        fixedExpense: List<RealmExpenseItem>,
        balance: Int,
        defaultHaruby: Int,
        dailyBudgets: List<RealmDailyBudget>
    ) {
        self.init()
        self.startDate = startDate
        self.endDate = endDate
        self.fixedIncome = fixedIncome
        self.fixedExpense = fixedExpense
        self.balance = balance
        self.defaultHaruby = defaultHaruby
        self.dailyBudgets = dailyBudgets
    }
    
    convenience init(_ salaryBudget: SalaryBudget) {
        self.init()
        self.startDate = salaryBudget.startDate
        self.endDate = salaryBudget.endDate
        self.fixedIncome = salaryBudget.fixedIncome
        self.balance = salaryBudget.balance
        self.defaultHaruby = salaryBudget.defaultHaruby
        
        // [ExpenseItem] -> [RealmExpenseItem]
        let realmExpenseItems = salaryBudget.fixedExpense.map { RealmExpenseItem($0) }
        // [RealmExpenseItem] -> List<RealmExpenseItem>
        let expenseItems = List<RealmExpenseItem>()
        expenseItems.append(objectsIn: realmExpenseItems)
        
        self.fixedExpense = expenseItems
        
        // [DailyBudget] -> [RealmDailyBudget]
        let realmDailyBudgets = salaryBudget.dailyBudgets.map { RealmDailyBudget($0) }
        // [RealmDailyBudget] -> List<RealmDailyBudget>
        let dailyBudgets = List<RealmDailyBudget>()
        dailyBudgets.append(objectsIn: dailyBudgets)
        
        self.dailyBudgets = dailyBudgets
    }
}

extension RealmSalaryBudget {
    func toEntity() -> SalaryBudget {
        SalaryBudget(
            startDate: self.startDate,
            endDate: self.endDate,
            fixedIncome: self.fixedIncome,
            // List<RealmExpenseItem> -> [RealmExpenseItem] -> [ExpenseItem]
            fixedExpense: Array(self.fixedExpense).map { $0.toEntity() },
            balance: self.balance,
            defaultHaruby: self.defaultHaruby,
            // List<RealmDailyBudget> -> [RealmDailyBudget] -> [DailyBudget]
            dailyBudgets: Array(self.dailyBudgets).map { $0.toEntity() }
        )
    }
}

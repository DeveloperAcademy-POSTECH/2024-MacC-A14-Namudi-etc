//
//  RealmSalaryBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmSalaryBudget: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var fixedIncome: Int
    @Persisted var fixedExpense: List<RealmTransactionItem>
    @Persisted var balance: Int
    @Persisted var defaultHaruby: Int
    @Persisted var dailyBudgets: List<RealmDailyBudget>
    
    convenience init(
        id: String,
        startDate: Date,
        endDate: Date,
        fixedIncome: Int,
        fixedExpense: List<RealmTransactionItem>,
        balance: Int,
        defaultHaruby: Int,
        dailyBudgets: List<RealmDailyBudget>
    ) {
        self.init()
        self.id = id
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
        self.id = salaryBudget.id
        self.startDate = salaryBudget.startDate
        self.endDate = salaryBudget.endDate
        self.fixedIncome = salaryBudget.fixedIncome
        self.balance = salaryBudget.balance
        self.defaultHaruby = salaryBudget.defaultHaruby
        
        // [TransactionItem] -> [RealmTransactionItem]
        let realmTransactionItems = salaryBudget.fixedExpense.map { RealmTransactionItem($0) }
        // [RealmTransactionItem] -> List<RealmTransactionItem>
        let listTransactionItem = List<RealmTransactionItem>()
        listTransactionItem.append(objectsIn: realmTransactionItems)
        
        self.fixedExpense = listTransactionItem
        
        // [DailyBudget] -> [RealmDailyBudget]
        let realmDailyBudgets = salaryBudget.dailyBudgets.map { RealmDailyBudget($0) }
        // [RealmDailyBudget] -> List<RealmDailyBudget>
        let listDailyBudgets = List<RealmDailyBudget>()
        listDailyBudgets.append(objectsIn: realmDailyBudgets)
        
        self.dailyBudgets = listDailyBudgets
    }
}

extension RealmSalaryBudget {
    func toEntity() -> SalaryBudget {
        SalaryBudget(
            id: self.id,
            startDate: self.startDate,
            endDate: self.endDate,
            fixedIncome: self.fixedIncome,
            // List<RealmTransactionItem> -> [RealmTransactionItem] -> [TransactionItem]
            fixedExpense: Array(self.fixedExpense).map { $0.toEntity() },
            balance: self.balance,
            defaultHaruby: self.defaultHaruby,
            // List<RealmDailyBudget> -> [RealmDailyBudget] -> [DailyBudget]
            dailyBudgets: Array(self.dailyBudgets).map { $0.toEntity() }
        )
    }
}

//
//  RealmDailyBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmDailyBudget: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var date: Date
    @Persisted var haruby: Int?
    @Persisted var memo: String
    @Persisted var expense: RealmExpenses?
    @Persisted var income: RealmExpenses?
    
    convenience init(
        id: UUID,
        date: Date,
        haruby: Int? = nil,
        memo: String,
        expense: RealmExpenses,
        income: RealmExpenses
    ) {
        self.init()
        self.id = id
        self.date = date
        self.haruby = haruby
        self.memo = memo
        self.expense = expense
        self.income = expense
    }
    
    convenience init(_ dailyBudget: DailyBudget) {
        self.init()
        self.id = dailyBudget.id
        self.date = dailyBudget.date
        self.haruby = dailyBudget.haruby
        self.memo = dailyBudget.memo
        self.expense = RealmExpenses(dailyBudget.expense)
        self.income = RealmExpenses(dailyBudget.income)
    }
}

extension RealmDailyBudget {
    func toEntity() -> DailyBudget {
        DailyBudget(
            id: self.id,
            date: self.date,
            haruby: self.haruby,
            memo: self.memo,
            expense: self.expense?.toEntity() ?? Expenses(total: 0, expenseItems: []),
            income: self.income?.toEntity() ?? Expenses(total: 0, expenseItems: [])
        )
    }
}

//
//  RealmDailyBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmDailyBudget: Object {
    @Persisted(primaryKey: true) var date: String
    @Persisted var haruby: Int?
    @Persisted var memo: String
    @Persisted var expenses: RealmExpenses
    
    convenience init(
        date: String,
        haruby: Int? = nil,
        memo: String,
        expenses: RealmExpenses
    ) {
        self.init()
        self.date = date
        self.haruby = haruby
        self.memo = memo
        self.expenses = expenses
    }
    
    convenience init(_ dailyBudget: DailyBudget) {
        self.init()
        self.date = dailyBudget.date
        self.haruby = dailyBudget.haruby
        self.memo = dailyBudget.memo
        self.expenses = RealmExpenses(dailyBudget.expenses)
    }
}

extension RealmDailyBudget {
    func toEntity() -> DailyBudget {
        DailyBudget(
            date: self.date,
            haruby: self.haruby,
            memo: self.memo,
            expenses: self.expenses.toEntity()
        )
    }
}

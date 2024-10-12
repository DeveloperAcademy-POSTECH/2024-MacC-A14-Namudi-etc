//
//  RealmDailyBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmDailyBudget: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var haruby: Int?
    @Persisted var memo: String
    @Persisted var expense: RealmTransactionRecord?
    @Persisted var income: RealmTransactionRecord?
    
    convenience init(
        id: String,
        date: Date,
        haruby: Int? = nil,
        memo: String,
        expense: RealmTransactionRecord,
        income: RealmTransactionRecord
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
        self.expense = RealmTransactionRecord(dailyBudget.expense)
        self.income = RealmTransactionRecord(dailyBudget.income)
    }
}

extension RealmDailyBudget {
    func toEntity() -> DailyBudget {
        DailyBudget(
            id: self.id,
            date: self.date,
            haruby: self.haruby,
            memo: self.memo,
            expense: self.expense?.toEntity() ?? TransactionRecord(total: 0, transactionItems: []),
            income: self.income?.toEntity() ?? TransactionRecord(total: 0, transactionItems: [])
        )
    }
}

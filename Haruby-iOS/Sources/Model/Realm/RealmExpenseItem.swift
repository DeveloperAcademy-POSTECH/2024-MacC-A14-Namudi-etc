//
//  RealmExpenseItem.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmExpenseItem: Object {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var name: String
    @Persisted var amount: Int
    
    convenience init(name: String, amount: Int) {
        self.init()
        self.name = name
        self.amount = amount
    }
    
    convenience init(_ expenseItem: ExpenseItem) {
        self.init()
        self.name = expenseItem.name
        self.amount = expenseItem.amount
    }
}

extension RealmExpenseItem {
    func toEntity() -> ExpenseItem {
        ExpenseItem(name: self.name, amount: self.amount)
    }
}

//
//  RealmExpenseItem.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmExpenseItem: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var price: Int
    
    convenience init(id: String, name: String, price: Int) {
        self.init()
        self.id = id
        self.name = name
        self.price = price
    }
    
    convenience init(_ expenseItem: ExpenseItem) {
        self.init()
        self.id = expenseItem.id
        self.name = expenseItem.name
        self.price = expenseItem.price
    }
}

extension RealmExpenseItem {
    func toEntity() -> ExpenseItem {
        ExpenseItem(
            id: self.id,
            name: self.name,
            price: self.price
        )
    }
}

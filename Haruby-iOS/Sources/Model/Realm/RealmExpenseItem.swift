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
    @Persisted var price: Int
    
    convenience init(name: String, price: Int) {
        self.init()
        self.name = name
        self.price = price
    }
    
    convenience init(_ expenseItem: ExpenseItem) {
        self.init()
        self.name = expenseItem.name
        self.price = expenseItem.price
    }
}

extension RealmExpenseItem {
    func toEntity() -> ExpenseItem {
        ExpenseItem(name: self.name, price: self.price)
    }
}

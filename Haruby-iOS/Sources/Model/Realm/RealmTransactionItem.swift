//
//  RealmExpenseItem.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

final class RealmTransactionItem: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var price: Int
    
    convenience init(id: String, name: String, price: Int) {
        self.init()
        self.id = id
        self.name = name
        self.price = price
    }
    
    convenience init(_ transactionItem: TransactionItem) {
        self.init()
        self.id = transactionItem.id
        self.name = transactionItem.name
        self.price = transactionItem.price
    }
}

extension RealmTransactionItem {
    func toEntity() -> TransactionItem {
        TransactionItem(
            id: self.id,
            name: self.name,
            price: self.price
        )
    }
}

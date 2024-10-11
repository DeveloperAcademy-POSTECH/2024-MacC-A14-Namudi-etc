//
//  RealmExpenses.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

// TODO: 모델명 수정
final class RealmExpenses: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var total: Int
    @Persisted var expenseItems: List<RealmExpenseItem>
    
    convenience init(
        id: String,
        total: Int,
        expenseItems: List<RealmExpenseItem>
    ) {
        self.init()
        self.id = id
        self.total = total
        self.expenseItems = expenseItems
    }
    
    convenience init(_ expenses: Expenses) {
        self.init()
        self.id = id
        self.total = expenses.total
        
        // [ExpenseItem] -> [RealmExpenseItem]으로 변환
        let realmExpenseItems = expenses.expenseItems.map { RealmExpenseItem($0) }
        
        // [RealmExpenseItem] -> List<RealmExpenseItem>으로 변환
        let expenseItems = List<RealmExpenseItem>()
        expenseItems.append(objectsIn: realmExpenseItems)
        
        self.expenseItems = expenseItems
    }
}

extension RealmExpenses {
    func toEntity() -> Expenses {
        Expenses(
            id: self.id,
            total: self.total,
            // List<RealmExpenseItem> -> [RealmExpenseItem] -> [ExpenseItem]
            expenseItems: Array(self.expenseItems).map { $0.toEntity() }
        )
    }
}

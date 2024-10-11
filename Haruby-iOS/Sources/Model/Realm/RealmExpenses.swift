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
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var total: Int
    @Persisted var expenseItems: List<RealmExpenseItem>
    
    convenience init(
        total: Int,
        expenseItems: List<RealmExpenseItem>
    ) {
        self.init()
        self.total = total
        self.expenseItems = expenseItems
    }
    
    convenience init(_ expenses: Expenses) {
        self.init()
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
            total: self.total,
            // List<RealmExpenseItem> -> [RealmExpenseItem] -> [ExpenseItem]
            expenseItems: Array(self.expenseItems).map { $0.toEntity() }
        )
    }
}

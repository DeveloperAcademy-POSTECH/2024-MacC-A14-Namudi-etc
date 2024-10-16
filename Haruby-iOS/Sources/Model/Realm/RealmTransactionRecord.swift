//
//  RealmExpenses.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RealmSwift

// TODO: 모델명 수정
final class RealmTransactionRecord: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var total: Int
    @Persisted var transactionItems: List<RealmTransactionItem>
    
    convenience init(
        id: String,
        total: Int,
        transactionItems: List<RealmTransactionItem>
    ) {
        self.init()
        self.id = id
        self.total = total
        self.transactionItems = transactionItems
    }
    
    convenience init(_ transactionRecord: TransactionRecord) {
        self.init()
        self.id = transactionRecord.id
        self.total = transactionRecord.total
        
        // [TransactionItem] -> [RealmTransactionItem]으로 변환
        let realmTransactionItems = transactionRecord.transactionItems.map { RealmTransactionItem($0) }
        
        // [RealmTransactionItem] -> List<RealmTransactionItem>으로 변환
        let listTransactionItem = List<RealmTransactionItem>()
        listTransactionItem.append(objectsIn: realmTransactionItems)
        
        self.transactionItems = listTransactionItem
    }
}

extension RealmTransactionRecord {
    func toEntity() -> TransactionRecord {
        TransactionRecord(
            id: self.id,
            total: self.total,
            // List<RealmTransactionItem> -> [RealmTransactionItem] -> [TransactionItem]
            transactionItems: Array(self.transactionItems).map { $0.toEntity() }
        )
    }
}

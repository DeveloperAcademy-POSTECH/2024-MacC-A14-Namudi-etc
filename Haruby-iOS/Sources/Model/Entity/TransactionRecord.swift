//
//  Expenses.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

// TODO: 모델명 수정
struct TransactionRecord {
    var id: String = UUID().uuidString
    var total: Int
    var transactionItems: [TransactionItem]
}

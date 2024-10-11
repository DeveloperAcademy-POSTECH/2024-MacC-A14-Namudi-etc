//
//  Expenses.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

// TODO: 모델명 수정
struct Expenses {
    var id: UUID = UUID()
    var total: Int
    var expenseItems: [ExpenseItem]
}

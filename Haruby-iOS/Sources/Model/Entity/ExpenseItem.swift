//
//  ExpenseItem.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

struct ExpenseItem {
    var id: String = UUID().uuidString
    var name: String
    var price: Int
}

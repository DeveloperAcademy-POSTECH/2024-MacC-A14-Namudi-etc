//
//  DailyBudget.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import SwiftUI

struct DailyBudget: Equatable {
    var id: String = UUID().uuidString
    var date: Date
    var haruby: Int?
    var memo: String
    var expense: TransactionRecord
    var income: TransactionRecord
}

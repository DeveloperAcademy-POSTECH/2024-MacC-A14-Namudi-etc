//
//  TransactionConstants.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/18/24.
//

import Foundation

enum TransactionType: Int {
    case expense = 0
    case income = 1
    
    var text: String {
        switch self {
        case .expense:
            "지출"
        case .income:
            "수입"
        }
    }
}

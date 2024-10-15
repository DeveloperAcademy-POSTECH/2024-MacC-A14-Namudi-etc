//
//  KeypadType.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/15/24.
//

import Foundation

struct CalculatorSymbol {
    static let plus = "+"
    static let minus = "−"
    static let multiply = "×"
    static let divide = "÷"
    static let deleteAll = "AC"
    static let deleteLast = ""
    static let equal = "="
    
    static let zeros: [String] = ["0", "00", "000"]
    static let operators: [String] = [plus, minus, multiply, divide]
    static let deletes: [String] = [deleteAll, deleteLast]
}

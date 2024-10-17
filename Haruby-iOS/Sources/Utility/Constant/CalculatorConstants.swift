//
//  CalculatorSymbol.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/16/24.
//

import Foundation
import UIKit

struct CalculatorSymbol {
    static let plus = "+"
    static let minus = "-"
    static let multiply = "×"
    static let divide = "÷"
    static let equal = "="
    static let deleteAll = "AC"
    static let deleteLast = "Delete"
    static let doubleZero = "00"
    static let tripleZero = "000"
}

enum KeypadButtonType: Int {
    enum Style {
        case text
        case image
    }
    
    // rawValue 0 ~ 11
    case zero, one, two, three, four, five, six, seven, eight, nine, doubleZero, tripleZero
    // rawValue 12 ~ 13
    case deleteAll, deleteLast
    // rawValue 14 ~ 18
    case plus, minus, multiply, divide, equal
    
    static let operators: [KeypadButtonType] = [.plus, .minus, .multiply, .divide]
    static let zeros: [KeypadButtonType] = [.zero, .doubleZero, .tripleZero]
    
    var style: Self.Style {
        switch self.rawValue {
        case 0...12: .text
        default: .image
        }
    }
    
    var title: String {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            return String(self.rawValue)
        case .doubleZero: // 00
            return CalculatorSymbol.doubleZero
        case .tripleZero: // 000
            return CalculatorSymbol.tripleZero
        case .deleteAll:
            return CalculatorSymbol.deleteAll
            
        case .plus:
            return CalculatorSymbol.plus
        case .minus:
            return CalculatorSymbol.minus
        case .multiply:
            return CalculatorSymbol.multiply
        case .divide:
            return CalculatorSymbol.divide
        case .equal:
            return CalculatorSymbol.equal
        case .deleteLast:
            return CalculatorSymbol.deleteLast
        }
    }
    
    var image: UIImage? {
        switch self {
        case .plus:
            return UIImage(systemName: "plus")
        case .minus:
            return UIImage(systemName: "minus")
        case .multiply:
            return UIImage(systemName: "multiply")
        case .divide:
            return UIImage(systemName: "divide")
        case .equal:
            return UIImage(systemName: "equal")
        case .deleteLast:
            return UIImage(systemName: "delete.left.fill")
        default:
            return nil
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
            return .Haruby.textBlack
        case .equal:
            return .Haruby.white
        case .plus, .minus, .multiply, .divide, .deleteAll, .deleteLast:
            return .Haruby.main
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
            return .Haruby.white
        case .equal:
            return .Haruby.main
        case .plus, .minus, .multiply, .divide, .deleteAll, .deleteLast:
            return .Haruby.mainBright15
        }
    }
    
    var touchDownBackgroundColor: UIColor {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
            return .Haruby.textBlack10
        case .equal:
            return .Haruby.main.withAlphaComponent(0.8)
        case .plus, .minus, .multiply, .divide, .deleteAll, .deleteLast:
            return .Haruby.mainBright.withAlphaComponent(0.5)
        
        }
    }
    
    var font: UIFont {
        return .pretendardRegular_24
    }
    
    var isSquare: Bool {
        if case .equal = self { return false }
        else { return true }
    }
}


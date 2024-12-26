//
//  KeypadButtonType.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - KeypadButtonType
enum KeypadButtonType: Int {
  
  static let zeros: [KeypadButtonType] = [.zero, .doubleZero, .tripleZero]
  static let numbers: [KeypadButtonType] = [.one, .two, .three, .four, .five, .six, .seven, .eight, .nine]
  static let operators: [KeypadButtonType] = [.plus, .minus]
  
  enum Style {
    case text
    case image
  }
  
  enum Symbol: String {
    case doubleZero = "00"
    case tripleZero = "000"
    case clear = "AC"
    case plus = "+"
    case minus = "-"
    case delete = "삭제"
  }
  
  // rawValue 0 ~ 11
  case zero, one, two, three, four, five, six, seven, eight, nine, doubleZero, tripleZero
  // rawValue 12
  case clear
  // rawValue 13 ~ 14
  case plus, minus
  // rawValue 15
  case delete
  
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
      return Self.Symbol.doubleZero.rawValue
    case .tripleZero: // 000
      return Self.Symbol.tripleZero.rawValue
    case .delete:
      return Self.Symbol.delete.rawValue
    case .plus:
      return Self.Symbol.plus.rawValue
    case .minus:
      return Self.Symbol.minus.rawValue
    case .clear:
      return Self.Symbol.clear.rawValue
    }
  }
  
  var image: Image {
    switch self {
    case .plus:
      return Image(systemName: "plus")
    case .minus:
      return Image(systemName: "minus")
    case .delete:
      return Image(systemName: "delete.left.fill")
    default:
      return Image(systemName: "circle")
    }
  }
  
  var foregroundColor: Color {
    switch self {
    case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
      return .textBlack
    case .delete, .plus, .minus, .clear:
      return .main
    }
  }
  
  var font: Font {
    switch self {
    case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
      return .pretendardMedium_24
    case .delete:
      return .sfPro(size: 22)
    case .plus, .minus:
      return .pretendardMedium_20
    case .clear:
      return .pretendardRegular_22
    }
  }
  
  
  var highlightBackgroundColor: Color {
    return .whiteDeep
  }
}

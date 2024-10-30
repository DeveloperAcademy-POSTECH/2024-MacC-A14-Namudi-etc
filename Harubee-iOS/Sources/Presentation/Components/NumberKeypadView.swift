//
//  NumberKeypadView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

public enum KeypadButtonType: Int {
  enum Style {
    case text
    case image
  }
  
  enum Symbol: String {
    case doubleZero = "00"
    case tripleZero = "000"
    case done = "입력"
    case plus = "+"
    case minus = "-"
    case delete = "삭제"
  }
  
  // rawValue 0 ~ 11
  case zero, one, two, three, four, five, six, seven, eight, nine, doubleZero, tripleZero
  // rawValue 12
  case done
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
    case .done:
      return Self.Symbol.done.rawValue
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
      return .black
    case .delete, .plus, .minus, .done:
      return .blue
    }
  }
  
  
  var highlightBackgroundColor: Color {
    return .gray.opacity(0.3)
  }
}

// MARK: - NumberKeypadView
public struct NumberKeypadView: View {
  
  private let keypads: [[KeypadButtonType]] = [
    [.one, .two, .three, .delete],
    [.four, .five, .six, .plus],
    [.seven, .eight, .nine, .minus],
    [.zero, .doubleZero, .tripleZero, .done]
  ]
  
  public init() { }
  
  public var body: some View {
    VStack(spacing: 10) {
      ForEach(keypads, id: \.self) { keypad in
        NumberKeypadRowView(keypad: keypad)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 15)
  }
}

// MARK: - NumberKeypadRowView
private struct NumberKeypadRowView: View {
  
  private let keypad: [KeypadButtonType]
  
  init(keypad: [KeypadButtonType]) {
    self.keypad = keypad
  }
  
  var body: some View {
    HStack(spacing: 10) {
      ForEach(keypad, id: \.self) { button in
        NumberKeypadColumnView(button: button)
      }
    }
  }
}

// MARK: - NumberKeypadColumnView
private struct NumberKeypadColumnView: View {
  @State private var isPressed = false
  
  private let button: KeypadButtonType
  
  init(button: KeypadButtonType) {
    self.button = button
  }
  
  var body: some View {
    ZStack {
      Color.gray
      
      Group {
        if button.style == .text {
          Text(button.title)
        } else {
          button.image
        }
      }
      .foregroundStyle(button.foregroundColor)
    }
    .frame(maxWidth: .infinity, maxHeight: 50)
    .clipShape(RoundedRectangle(cornerRadius: 5))
    .scaleEffect(isPressed ? 0.9 : 1.0)
    .onLongPressGesture(
      minimumDuration: 0.1,
      maximumDistance: 10) {
      } onPressingChanged: { isChanged in
        isPressed = isChanged
        
        if !isPressed { print(button.title) }
      }
  }
}

#Preview {
  NumberKeypadView()
}

//
//  NumberKeypadView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

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
      return .textBlack
    case .delete, .plus, .minus, .done:
      return .main
    }
  }
  
  var font: Font {
    switch self {
    case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
      return .pretendardMedium_24
    case .delete:
      return .system(size: 22, weight: .regular)
    case .plus, .minus:
      return .pretendardMedium_20
    case .done:
      return .pretendardSemibold_18
    }
  }
  
  
  var highlightBackgroundColor: Color {
    return .whiteDeep
  }
}

// MARK: - NumberKeypadView
struct NumberKeypadView: View {
  
  @Binding var text: String
  
  private let keypads: [[KeypadButtonType]] = [
    [.one, .two, .three, .delete],
    [.four, .five, .six, .plus],
    [.seven, .eight, .nine, .minus],
    [.zero, .doubleZero, .tripleZero, .done]
  ]
  
  public init(text: Binding<String>) {
    self._text = text
  }
  
  public var body: some View {
    VStack(spacing: 2) {
      ForEach(keypads, id: \.self) { rowKeypads in
        NumberKeypadRowView(text: $text, keypads: rowKeypads)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 15)
  }
}

// MARK: - NumberKeypadRowView
private struct NumberKeypadRowView: View {
  
  @Binding var text: String
  
  private let keypads: [KeypadButtonType]
  
  init(text: Binding<String>, keypads: [KeypadButtonType]) {
    self._text = text
    self.keypads = keypads
  }
  
  var body: some View {
    HStack(spacing: 2) {
      ForEach(keypads, id: \.self) { columnKeypads in
        NumberKeypadColumnView(text: $text, keypad: columnKeypads)
      }
    }
  }
}

// MARK: - NumberKeypadColumnView
private struct NumberKeypadColumnView: View {
  @State private var isPressed = false
  @Binding var text: String
  
  private let keypad: KeypadButtonType
  
  init(text: Binding<String>, keypad: KeypadButtonType) {
    self._text = text
    self.keypad = keypad
  }
  
  var body: some View {
    ZStack {
      keypad.highlightBackgroundColor.opacity(isPressed ? 1 : 0.0)
      
      Group {
        if keypad.style == .text {
          Text(keypad.title)
        } else {
          keypad.image
        }
      }
      .foregroundStyle(keypad.foregroundColor)
      .font(keypad.font)
    }
    .frame(maxWidth: .infinity, maxHeight: 50)
    .clipShape(RoundedRectangle(cornerRadius: 5))
    .contentShape(Rectangle())
    .scaleEffect(isPressed ? 0.9 : 1.0)
    .onLongPressGesture(
      minimumDuration: 0.1,
      maximumDistance: 10) {
      } onPressingChanged: { isPressed in
        self.isPressed = isPressed
        
        if !isPressed { text += keypad.title }
        else { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }
      }
  }
}

#Preview {
  @Previewable @State var text = "123"
  NumberKeypadView(text: $text)
}

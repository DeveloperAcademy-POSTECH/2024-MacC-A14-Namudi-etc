//
//  NumberKeypadView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

// MARK: - NumberKeypadView
struct NumberKeypadView: View {
  
  @Binding private var text: String
  
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
    .onChange(of: text) { oldValue, newValue in
      print(text)
    }
  }
}

// MARK: - NumberKeypadRowView
private struct NumberKeypadRowView: View {
  
  @Binding private var text: String
  
  private let keypads: [KeypadButtonType]
  
  init(
    text: Binding<String>,
    keypads: [KeypadButtonType]
  ) {
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
  @Binding private var text: String
  
  private let keypad: KeypadButtonType
  
  init(
    text: Binding<String>,
    keypad: KeypadButtonType
  ) {
    self._text = text
    self.keypad = keypad
  }
  
  var body: some View {
    Group {
      if keypad.style == .text {
        Text(keypad.title)
      } else {
        keypad.image
      }
    }
    .frame(maxWidth: .infinity, maxHeight: 60)
    .background(keypad.highlightBackgroundColor.opacity(isPressed ? 1 : 0))
    .foregroundStyle(keypad.foregroundColor)
    .font(keypad.font)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .contentShape(Rectangle())
    .scaleEffect(isPressed ? 0.9 : 1.0)
    .onTapGesture {
      
      text = processKeypad(keypad, text: text)
      
      self.isPressed = true
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        withAnimation {
          self.isPressed = false
        }
        
      }
      UIImpactFeedbackGenerator(style: .soft).impactOccurred()
      
    }
  }
  
  // MARK: - func processKeypad
  private func processKeypad(
    _ keypadType: KeypadButtonType,
    text: String
  ) -> String {
    var newText = text
    
    switch keypadType {
    case .delete:
      newText = processDeleteType(
        keypadType,
        text: text
      )
    case .plus, .minus:
      newText = processOperatorType(
        keypadType,
        text: text
      )
    case .done:
      newText = processDoneType(
        keypadType,
        text: text
      )
    default:
      newText = processNumberType(
        keypadType,
        text: text
      )
    }
    
    return newText
  }
  
  // MARK: - func processNumberType
  private func processNumberType(
    _ keypadType: KeypadButtonType,
    text: String
  ) -> String {
    
    // 0이 눌렸을 때
    if KeypadButtonType.zeros.contains(keypadType) {
      // 0이 동작하지 않아야 하는 경우
      
      // - 텍스트가 비어있을 때
      if text.isEmpty {
        return KeypadButtonType.zero.title
      }
      
      let lastText = String(text.last!)
      
      // - 길이가 1이고 마지막 텍스트가 0일 때
      if text.count == 1
          && lastText == KeypadButtonType.zero.title {
        return KeypadButtonType.zero.title
      }
      
      // - 마지막 텍스트가 연산자일 때
      if lastText == KeypadButtonType.plus.title
          || lastText == KeypadButtonType.minus.title {
        return text
      }
    }
    
    if text.count == 1 && String(text.last!) == KeypadButtonType.zero.title {
      return keypadType.title
    }
    
    
    return text + keypadType.title
  }
  
  // MARK: - processOperatorType
  private func processOperatorType(
    _ keypadType: KeypadButtonType,
    text: String
  ) -> String {
    
    if text.isEmpty { return text }
    
    let lastText = String(text.last!)
    
    if lastText == KeypadButtonType.plus.title
        || lastText == KeypadButtonType.minus.title {
      return text
    }
    
    return text + keypadType.title
  }
  
  // MARK: - processDeleteType
  private func processDeleteType(
    _ keypadType: KeypadButtonType,
    text: String
  ) -> String {
    
    if text.isEmpty { return text }
    
    var newText = text
    let _ = newText.popLast()
    
    if newText.isEmpty { newText = "0" }
    return newText
  }
  
  // MARK: - processDoneType
  private func processDoneType(
    _ keypadType: KeypadButtonType,
    text: String
  ) -> String {
    var before = 0
    var current = ""
    var op = "+"
    
    var index = 0
    
    if text[index] == "-" {
      op = "-"
      index += 1
    }
    
    while index < text.count {
      let curCharacter = text[index]
      
      if curCharacter.isSingleNumber {
        current.append(curCharacter)
      } else if ["+", "-"].contains(curCharacter) {
        before = processExpression(
          before: before,
          current: Int(current)!,
          op: op
        )
        current = ""
        op = curCharacter
      }
      
      index += 1
    }
    
    if !current.isEmpty {
      before = processExpression(before: before, current: Int(current)!, op: op)
    }
    
    return before.decimal
  }
  
  // MARK: - processExpression
  private func processExpression(
    before: Int,
    current: Int,
    op: String
  ) -> Int {
    if op == "+" {
      return before + current
    } else {
      return before - current
    }
  }
  
}


// MARK: - KeypadButtonType
private enum KeypadButtonType: Int {
  
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

// MARK: - Preview
#Preview {
  @Previewable @State var text: String = ""
  return NumberKeypadView(text: $text)
}

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
  
  @Binding private var expression: String
  private let buttonAction: (Bool) -> Void
  
  private let keypads: [[KeypadButtonType]] = [
    [.one, .two, .three, .delete],
    [.four, .five, .six, .plus],
    [.seven, .eight, .nine, .minus],
    [.zero, .doubleZero, .tripleZero, .done]
  ]
  
  public init(
    expression: Binding<String>,
    buttonAction: @escaping (Bool) -> Void
  ) {
    self._expression = expression
    self.buttonAction = buttonAction
  }
  
  public var body: some View {
    VStack(spacing: 2) {
      ForEach(keypads, id: \.self) { rowKeypads in
        NumberKeypadRowView(
          expression: $expression,
          keypads: rowKeypads
        )
        .environment(\.buttonAction) { bool in
          buttonAction(bool)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: - NumberKeypadRowView
private struct NumberKeypadRowView: View {
  
  @Binding private var expression: String
  
  private let keypads: [KeypadButtonType]
  
  init(
    expression: Binding<String>,
    keypads: [KeypadButtonType]
  ) {
    self._expression = expression
    self.keypads = keypads
  }
  
  var body: some View {
    HStack(spacing: 2) {
      ForEach(keypads, id: \.self) { columnKeypads in
        NumberKeypadButton(
          expression: $expression,
          keypad: columnKeypads
        )
      }
    }
  }
}

// MARK: - NumberKeypadButton
private struct NumberKeypadButton: View {
  @Environment(\.buttonAction) private var buttonAction
  @State private var isPressed = false
  @Binding private var expression: String
  
  private let keypad: KeypadButtonType
  
  private let calculator = CalculatorLogic()
  
  init(
    expression: Binding<String>,
    keypad: KeypadButtonType
  ) {
    self._expression = expression
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
      
      self.expression = calculator.processKeypad(
        keypad,
        expression: expression
      )
      
      switch keypad {
      case .done:
        buttonAction(true)
      default:
        buttonAction(false)
      }
      
      self.isPressed = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        withAnimation {
          self.isPressed = false
        }
      }
      UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
  }
}

// MARK: - Preview
#Preview {
  @Previewable @State var expression: String = ""
  return NumberKeypadView(expression: $expression) { bool in
//    print("\(bool)")
  }
}

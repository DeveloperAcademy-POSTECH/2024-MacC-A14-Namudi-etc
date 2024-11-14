//
//  NumberKeypadView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI


// MARK: - NumberKeypadView
struct NumberKeypadView: View {
  
  @State private var expression: String
  @Binding private var amount: Int
  private let buttonAction: (Bool) -> Void
  
  private let keypads: [[KeypadButtonType]] = [
    [.one, .two, .three, .clear],
    [.four, .five, .six, .plus],
    [.seven, .eight, .nine, .minus],
    [.zero, .doubleZero, .tripleZero, .delete]
  ]
  
  init(
    amount: Binding<Int>,
    buttonAction: @escaping (Bool) -> Void
  ) {
    self._amount = amount
    self.buttonAction = buttonAction
    self._expression = State(wrappedValue: amount.wrappedValue.decimal)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      ExpressionView(expression: $expression)
      
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
      .padding(.top, 26)
      .padding(.horizontal, 16)
      .padding(.bottom, 31)
    }
    .frame(maxWidth: .infinity)
  }
}

private struct ExpressionView: View {
  @Binding var expression: String
  
  var body: some View {
    HStack(spacing: 20) {
      Text(expression)
      
      Spacer()
      
      Text("완료")
        .tapFeedback {
          
        }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 22)
    .padding(.vertical, 16)
    .background(.whiteDeep)
    .font(.pretendardMedium_16)
    .foregroundStyle(.textBlack)
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
    .foregroundStyle(keypad.foregroundColor)
    .font(keypad.font)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .contentShape(Rectangle())
    .tapFeedback {
      self.expression = calculator.processKeypad(
        keypad,
        expression: expression
      )
      
      //      switch keypad {
      //      case .clear:
      //        buttonAction(true)
      //      default:
      //        buttonAction(false)
      //      }
    }
  }
}

// MARK: - Preview
#Preview {
  @Previewable @State var amount: Int = 10000000
  return NumberKeypadView(amount: $amount) { bool in
    print("\(bool)")
  }
}

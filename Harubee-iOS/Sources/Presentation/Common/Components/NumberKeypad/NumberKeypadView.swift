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
  
  private let keypads: [[KeypadButtonType]] = [
    [.one, .two, .three, .clear],
    [.four, .five, .six, .plus],
    [.seven, .eight, .nine, .minus],
    [.zero, .doubleZero, .tripleZero, .delete]
  ]
  
  init(
    amount: Binding<Int>
  ) {
    self._amount = amount
    self._expression = State(wrappedValue: amount.wrappedValue.decimal)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      
      expressionView
      
      VStack(spacing: 2) {
        ForEach(keypads, id: \.self) { rowKeypads in
          NumberKeypadRowView(
            keypads: rowKeypads,
            expression: $expression,
            amount: $amount
          )
        }
      }
      .padding(.top, 26)
      .padding(.horizontal, 16)
      .padding(.bottom, 31)
    }
    .frame(maxWidth: .infinity)
  }
  
  private var expressionView: some View {
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
  let keypads: [KeypadButtonType]
  
  @Binding var expression: String
  @Binding var amount: Int
  
  var body: some View {
    HStack(spacing: 2) {
      ForEach(keypads, id: \.self) { columnKeypads in
        NumberKeypadButton(
          keypad: columnKeypads,
          expression: $expression,
          amount: $amount
        )
      }
    }
  }
}

// MARK: - NumberKeypadButton
private struct NumberKeypadButton: View {
  let keypad: KeypadButtonType
  
  @Binding var expression: String
  @Binding var amount: Int
  
  private let calculator = CalculatorLogic()
  
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
      let (newExpression, newAmount) = calculator.processKeypad(
        keypad,
        expression: expression
      )
      self.expression = newExpression
      self.amount = newAmount
    }
  }
}

// MARK: - Preview
#Preview {
  @Previewable @State var amount: Int = 10000000
  @Previewable @State var isVisible: Bool = false
  
  VStack {
    Button {
      isVisible.toggle()
    } label: {
      Text("Button")
    }
    
    NumberKeypadView(
      amount: $amount
    )
  }
}

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
  @Binding private var amount: String
  
  private let doneAction: () -> Void
  
  init(
    amount: Binding<String>,
    doneAction: @escaping () -> Void
  ) {
    self._amount = amount
    
    let exp = amount.wrappedValue.replacingOccurrences(of: "원", with: "")
    self._expression = State(wrappedValue: exp)
    self.doneAction = doneAction
  }
  
  var body: some View {
    VStack(spacing: 0) {
      ExpressionView(
        expression: $expression,
        doneAction: doneAction
      )
      
      NumberKeypadButton(
        expression: $expression,
        amount: $amount
      )
    }
    .frame(maxWidth: .infinity)
    .background(.whiteDefault)
  }
}

// MARK: - ExpressionView
private struct ExpressionView: View {
  @Binding var expression: String
  
  let doneAction: () -> Void
  
  private let scrollPositionID = "target"
  
  var body: some View {
    HStack(spacing: 20) {
      ViewThatFits {
        Text(expression)
          .lineLimit(1)
        
        scrollText
      }

      Spacer()
      
      Text("완료")
        .tapFeedback {
          self.doneAction()
        }
    }
    .frame(maxWidth: .infinity, maxHeight: 50)
    .padding(.horizontal, 22)
    .background(.whiteDeep)
    .font(.pretendardMedium_16)
    .foregroundStyle(.textBlack)
  }
  
  private var scrollText: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal) {
        HStack(spacing: 0) {
          Text(expression)
            .lineLimit(1)
            
          Image(systemName: "poweron")
            .resizable()
            .frame(maxWidth: 2, maxHeight: 20)
            .foregroundStyle(.main)
            .id(scrollPositionID)
        }
      }
      .scrollIndicators(.never)
      .onChange(of: expression, initial: true) { _, _ in
        proxy.scrollTo(scrollPositionID, anchor: .trailing)
      }
    }
  }
}

// MARK: - NumberKeypadButton
private struct NumberKeypadButton: View {
  
  private let keypads: [[KeypadButtonType]] = [
    [.one, .two, .three, .clear],
    [.four, .five, .six, .plus],
    [.seven, .eight, .nine, .minus],
    [.zero, .doubleZero, .tripleZero, .delete]
  ]
  
  private let calculator = CalculatorLogic()
  
  @Binding var expression: String
  @Binding var amount: String
  
  var body: some View {
    VStack(spacing: 2) {
      ForEach(keypads, id: \.self) { rowKeypads in
        
        // rows
        HStack(spacing: 2) {
          ForEach(rowKeypads, id: \.self) { keypad in
            
            // columns
            keypadButton(keypad)
          }
        }
      }
    }
    .padding(.top, 26)
    .padding(.horizontal, 16)
//    .padding(.bottom, 31)
  }
  
  @ViewBuilder
  private func keypadButton(_ keypad: KeypadButtonType) -> some View {
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
    .tapFeedback(haptic: .soft) {
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
  @Previewable @State var amount: String = "10000000"
  @Previewable @State var isVisible: Bool = false
  
  VStack {
    Button {
      isVisible.toggle()
    } label: {
      Text("Button")
    }
    
    NumberKeypadView(
      amount: $amount
    ) {
      print("Tap")
    }
  }
}

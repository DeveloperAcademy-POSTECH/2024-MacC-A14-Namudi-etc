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
  
  var body: some View {
    HStack(spacing: 10) {
      ExpressionText(expression: $expression)

      Spacer()
      
      Button {
        self.doneAction()
      } label: {
        Text("완료")
      }
    }
    .frame(maxWidth: .infinity, maxHeight: 50)
    .padding(.horizontal, 22)
    .background(.whiteDeep)
    .font(.pretendardMedium_16)
    .foregroundStyle(.textBlack)
  }
}

// MARK: - ExpressionText
private struct ExpressionText: View {
  @State private var timer = Timer.publish(
    every: 0.5, on: .main, in: .common
  ).autoconnect()
  @State private var isVisible: Bool = true
  @State private var isExpressionChanging: Bool = false
  
  @Binding var expression: String
  
  private let scrollPositionID = "target"
  
  var body: some View {
    ViewThatFits {
      expressionText
        .onChange(of: expression) { _, _ in
          temporarilyPauseCursorBlinking()
        }
      
      ScrollViewReader { proxy in
        ScrollView(.horizontal) {
          expressionText
        }
        .scrollIndicators(.never)
        .onChange(of: expression, initial: true) { _, _ in
          temporarilyPauseCursorBlinking()
          proxy.scrollTo(scrollPositionID, anchor: .trailing)
        }
      }
    }
    .onReceive(timer) { _ in
      if !isExpressionChanging {
        withAnimation {
          isVisible.toggle()
        }
      }
    }
  }
  
  private var expressionText: some View {
    HStack(spacing: 1) {
      Text(expression)
        .lineLimit(1)
      
      Image(systemName: "poweron")
        .resizable()
        .frame(maxWidth: 2, maxHeight: 20)
        .foregroundStyle(
          isExpressionChanging || isVisible ? .main : .clear
        )
        .id(scrollPositionID)
    }
  }
  
  private func temporarilyPauseCursorBlinking() {
    self.isExpressionChanging = true
    self.isVisible = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.isExpressionChanging = false
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
    Button {
      let (newExpression, newAmount) = calculator.processKeypad(
        keypad,
        expression: expression
      )
      self.expression = newExpression
      self.amount = newAmount
    } label: {
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
    }
    .buttonStyle(CustomButtonStyle(
      tappedBackgroundColor: .textBright.opacity(0.7),
      cornerRadius: 12
    ))
  }
}


// MARK: - Preview
#Preview {
  @Previewable @State var amount: String = 
  """
  1,000,000,000,000+1,000,000,000+1,000,000
  """
  @Previewable @State var amount1: String =
  """
  1,000,000,000
  """
  @Previewable @State var isVisible: Bool = false
  
  VStack {
    Button {
      isVisible.toggle()
    } label: {
      Text("Button")
    }
    
//    NumberKeypadView(
//      amount: $amount
//    ) {
//      print("Tap")
//    }
    
    NumberKeypadView(
      amount: $amount1
    ) {
      print("Tap")
    }
  }
}

//
//  TransactionInputSheet.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

struct TransactionInputView: View {
  
  @State private var hightlightLabelAmount: Int = 62000
  
  @State private var isUpdated: Bool = false
  @State private var isFocusedExpense: Bool = true
  
  init(isFocusedExpense: Bool) {
    self._isFocusedExpense = State(initialValue: isFocusedExpense)
  }
  
  var body: some View {
    VStack {
      BottomSheetHeaderView(title: "실제 지출 및 수입 입력")
      
      TransactionBodyItemView(isFocusedExpense: $isFocusedExpense)
      
      Spacer()
      
      AmountResultText(
        numberText: .constant("test"),
        isUpdated: $isUpdated
      )
      .padding(.horizontal, 37)
      
      MainColorButton(
        title: "저장하기",
        isEnabled: $isUpdated
      ) {
        print("저장하기 Tap")
      }
      
      NumberKeypadView(text: .constant("test"))
    }
    .frame(maxWidth: .infinity)
    .onAppear {
      print(isFocusedExpense)
    }
  }
}



private struct TransactionBodyItemView: View {
  @Binding private var isFocusedExpense: Bool
  
  init(isFocusedExpense: Binding<Bool>) {
    self._isFocusedExpense = isFocusedExpense
  }
  
  var body: some View {
    HStack(spacing: 9) {
      TransactionItemButton(title: "수입", amount: 1000)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(
              Color.mainBright,
              lineWidth: isFocusedExpense ? 1 : 0
            )
        )
        .onTapGesture {
          isFocusedExpense = true
        }
      
      TransactionItemButton(title: "지출", amount: 10000)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(
              Color.mainBright,
              lineWidth: isFocusedExpense ? 0 : 1
            )
        )
        .onTapGesture {
          isFocusedExpense = false
        }
    }
    .padding(.top, 36)
    .padding(.horizontal, 16)
  }
}

#Preview {
  TransactionInputView(isFocusedExpense: true)
}

//
//  TransactionInputSheet.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared
import Domain

struct TransactionInputView: View {
  @State private var viewModel: TransactionInputViewModel
  
  @State private var expression: String = ""
  
  @State private var isUpdated: Bool = false
  @State private var isEnabled: Bool = false
  @State private var isFocusedExpense: Bool = true
  
  init(
    viewModel: TransactionInputViewModel,
    isFocusedExpense: Bool
  ) {
    self._viewModel = State(initialValue: viewModel)
    self._isFocusedExpense = State(initialValue: isFocusedExpense)
  }
  
  var body: some View {
    VStack {
      BottomSheetHeaderView(title: "실제 지출 및 수입 입력")
      
      TransactionBodyItemView(
        isFocusedExpense: $isFocusedExpense
      )
      
      Spacer()
      
      AmountResultText(
        numberText: $expression,
        isUpdated: $isUpdated
      )
      .padding(.horizontal, 40)
      
      MainColorButton(
        title: "저장하기",
        isEnabled: $isEnabled
      ) {
        self.isEnabled = isEnabled
        if isEnabled {
          self.isUpdated = true
          
          viewModel.send(.doneButtonTapped(
            expression.numberFormat ?? 0,
            isFocusedExpense
          ))
        }
      }
      
      NumberKeypadView(expression: $expression) { isEnabled in
        self.isUpdated = true
      }
    }
    .frame(maxWidth: .infinity)
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
  TransactionInputView(
    viewModel: DIContainer.shared.makeTransactionInputViewModel(
      salaryBudget: SalaryBudget.default,
      dailyBudget: DailyBudget.default
    ),
    isFocusedExpense: true
  )
}

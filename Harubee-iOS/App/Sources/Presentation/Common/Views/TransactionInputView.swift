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
  @Environment(\.dismiss) private var dismiss
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
        dailyBudget: viewModel.state.dailyBudget,
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
        self.viewModel.send(.saveButtonTapped)
        
        self.dismiss()
      }
      
      NumberKeypadView(expression: $expression) { isEnabled in
        self.isEnabled = isEnabled
        if isEnabled {
          self.isUpdated = true
          
          viewModel.send(.doneButtonTapped(
            expression.numberFormat ?? 0,
            isFocusedExpense
          ))
        }
      }
    }
    .frame(maxWidth: .infinity)
    .onChange(of: isFocusedExpense) { _, _ in
      if isFocusedExpense {
        self.expression = self.viewModel.state.dailyBudget.expense?.decimal ?? ""
      } else {
        self.expression = self.viewModel.state.dailyBudget.income?.decimal ?? ""
      }
    }
  }
}



private struct TransactionBodyItemView: View {
  @Binding private var isFocusedExpense: Bool
  
  private let dailyBudget: DailyBudget
  
  init(
    dailyBudget: DailyBudget,
    isFocusedExpense: Binding<Bool>
  ) {
    self.dailyBudget = dailyBudget
    self._isFocusedExpense = isFocusedExpense
  }
  
  var body: some View {
    HStack(spacing: 9) {
      TransactionItemButton(
        title: "수입",
        amount: dailyBudget.income
      )
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(
              Color.mainBright,
              lineWidth: isFocusedExpense ? 0 : 2
            )
        )
        .onTapGesture {
          isFocusedExpense = false
        }
      
      TransactionItemButton(
        title: "지출",
        amount: dailyBudget.expense
      )
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(
              Color.mainBright,
              lineWidth: isFocusedExpense ? 2 : 0
            )
        )
        .onTapGesture {
          isFocusedExpense = true
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

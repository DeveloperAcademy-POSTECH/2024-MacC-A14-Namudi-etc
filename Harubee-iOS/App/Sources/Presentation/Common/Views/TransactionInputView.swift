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
  @State private var isAlert: Bool = false
  
  private let beforeExpense: Int?
  private let beforeIncome: Int?
  
  init(
    viewModel: TransactionInputViewModel,
    isFocusedExpense: Bool
  ) {
    self._viewModel = State(initialValue: viewModel)
    self._isFocusedExpense = State(initialValue: isFocusedExpense)
    
    self.beforeExpense = viewModel.state.dailyBudget.expense
    self.beforeIncome = viewModel.state.dailyBudget.income
    
    self._expression = State(
      initialValue: isFocusedExpense
      ? beforeExpense?.decimal ?? ""
      : beforeIncome?.decimal ?? ""
    )
  }
  
  var body: some View {
    VStack {
      BottomSheetHeaderView(title: "실제 지출 및 수입 입력")
      
      TransactionBodyItemView(
        dailyBudget: viewModel.state.dailyBudget,
        isFocusedExpense: $isFocusedExpense
      )
      .padding(.top, 42)
      .padding(.horizontal, 16)
      
      Spacer()
      
      AmountResultText(
        numberText: $expression
      ) {
        self.isUpdated = false
        self.isEnabled = false
        
        let before = isFocusedExpense
        ? self.beforeExpense
        : self.beforeIncome
        
        viewModel.send(.resetButtonTapped(
          before,
          isFocusedExpense
        ))
        self.expression = before?.decimal ?? ""
      }
      .padding(.horizontal, 40)
      
      MainColorButton(
        title: "저장하기",
        isEnabled: $isEnabled,
        cornerRadius: 0
      ) {
        self.isAlert = true
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
    .ignoresSafeArea(edges: .bottom)
    .onChange(of: isFocusedExpense) { _, _ in
      if isFocusedExpense {
        self.expression = self.viewModel.state.dailyBudget.expense?.decimal ?? ""
      } else {
        self.expression = self.viewModel.state.dailyBudget.income?.decimal ?? ""
      }
    }
    .alert(
      "실제 지출 및 수입 저장하기",
      isPresented: $isAlert
    ) {
      Button(role: .cancel) {
        
      } label: {
        Text("취소")
      }

      Button {
        self.viewModel.send(.saveButtonTapped)
        self.dismiss()
      } label: {
        Text("저장")
      }
    } message: {
      let dailyBudget = self.viewModel.state.dailyBudget
      Text("수입 \((dailyBudget.income ?? 0).decimalWithWon), 지출 \((dailyBudget.expense ?? 0).decimalWithWon)으로 저장하시겠습니까?")
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
        RoundedRectangle(cornerRadius: 5)
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
        RoundedRectangle(cornerRadius: 5)
          .stroke(
            Color.mainBright,
            lineWidth: isFocusedExpense ? 2 : 0
          )
      )
      .onTapGesture {
        isFocusedExpense = true
      }
    }
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

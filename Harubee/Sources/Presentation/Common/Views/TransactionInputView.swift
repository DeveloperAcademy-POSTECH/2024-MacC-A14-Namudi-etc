//
//  TransactionInputSheet.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

enum TransactionFocusType {
  case expense
  case income
  case none
}

struct TransactionInputView: View {
  @Environment(MainCoordinator.self) private var coordinator
  @State private var viewModel: TransactionInputViewModel
  @State private var transactionFocusType: TransactionFocusType
  
  @State private var isUpdated: Bool = false
  @State private var isFocused: Bool = true
  
  @State private var expense: String
  @State private var income: String
  
  private let beforeExpense: Int?
  private let beforeIncome: Int?
  
  init(
    viewModel: TransactionInputViewModel,
    transactionFocusType: TransactionFocusType
  ) {
    self._viewModel = State(initialValue: viewModel)
    self._transactionFocusType = State(initialValue: transactionFocusType)
    
    let expense = viewModel.state.dailyBudget.expense
    let income = viewModel.state.dailyBudget.income
    
    self.beforeExpense = expense
    self.beforeIncome = income
    
    self._expense = State(
      initialValue: expense?.decimal ?? ""
    )
    self._income = State(
      initialValue: income?.decimal ?? ""
    )
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        TransactionBodyItemView(
          expense: $expense,
          income: $income,
          transactionFocusType: $transactionFocusType
        )
        .padding(.top, 42)
        .padding(.horizontal, 16)
        
        Spacer()
        
        MainColorBottomButton(
          title: "저장하기",
          isEnabled: $isUpdated
        ) {
          self.viewModel.send(.saveButtonTapped)
          self.coordinator.dismissTransactionInputSheet()
        }
      }
      .frame(maxWidth: .infinity)
      
      if isFocused {
        NumberKeypadView(
          amount: transactionFocusType == .expense
          ? $expense : $income
        ) {
          transactionFocusType = .none
          
          viewModel.send(.doneButtonTapped(
            income, expense
          ))
        }
      }
    }
    .id(transactionFocusType)
    .navigationBarStyle(.sheet(title: "실제 지출 및 수입 입력"))
    .onChange(of: transactionFocusType) { _, _ in
      switch transactionFocusType {
      case .income, .expense:
        self.isFocused = true
      case .none:
        self.isFocused = false
        
        if expense.numberFormat == beforeExpense
            && income.numberFormat == beforeIncome {
          isUpdated = false
        } else {
          isUpdated = true
        }
      }
    }
  }
}

private struct TransactionBodyItemView: View {
  
  @Binding var expense: String
  @Binding var income: String
  @Binding var transactionFocusType: TransactionFocusType
  
  var body: some View {
    HStack(spacing: 9) {
      TransactionItemButton(
        title: "수입",
        amount: income.numberFormat
      )
      .overlay(
        RoundedRectangle(cornerRadius: 5)
          .stroke(
            Color.mainBright,
            lineWidth: transactionFocusType == .income
            ? 2 : 0
          )
      )
      .tapFeedback(tappedBackgroundColor: .clear) {
        transactionFocusType = .income
      }
      
      TransactionItemButton(
        title: "지출",
        amount: expense.numberFormat
      )
      .overlay(
        RoundedRectangle(cornerRadius: 5)
          .stroke(
            Color.mainBright,
            lineWidth: transactionFocusType == .expense
            ? 2 : 0
          )
      )
      .tapFeedback(tappedBackgroundColor: .clear) {
        transactionFocusType = .expense
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
    transactionFocusType: .none
  )
}

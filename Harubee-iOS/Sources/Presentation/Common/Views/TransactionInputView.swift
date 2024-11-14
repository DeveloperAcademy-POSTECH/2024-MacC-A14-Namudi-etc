//
//  TransactionInputSheet.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct TransactionInputView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: TransactionInputViewModel
  
  @State private var expression: String = ""
  @State private var isUpdated: Bool = false
  @State private var isEnabled: Bool = false
  @State private var isFocusedExpense: Bool = true
  
  @State private var isAlert: Bool = false
  @State private var alertTitle: String = ""
  
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
      
      MainColorBottomButton(
        title: "저장하기",
        isEnabled: $isEnabled
      ) {
        let dailyBudget = viewModel.state.dailyBudget
        
        if let _ = dailyBudget.expense,
           let _ = dailyBudget.income {
          self.viewModel.send(.saveButtonTapped)
          self.dismiss()
        } else {
          self.isAlert = true
          self.alertTitle = dailyBudget.expense == nil 
          ? "지출"
          : "수입"
        }
      }
      
//      NumberKeypadView(expression: $expression) { isEnabled in
//        self.isEnabled = isEnabled
//        if isEnabled {
//          self.isUpdated = true
//          
//          viewModel.send(.doneButtonTapped(
//            expression.numberFormat ?? 0,
//            isFocusedExpense
//          ))
//        }
//      }
    }
    .frame(maxWidth: .infinity)
    .onChange(of: isFocusedExpense) { _, _ in
      if isFocusedExpense {
        self.expression = self.viewModel.state.dailyBudget.expense?.decimal ?? ""
      } else {
        self.expression = self.viewModel.state.dailyBudget.income?.decimal ?? ""
      }
    }
    .alert(
      "\(alertTitle)이 입력되지 않았어요",
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
        Text("확인")
      }
    } message: {
      Text("\(alertTitle)을 0원으로 저장하시겠습니까?")
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

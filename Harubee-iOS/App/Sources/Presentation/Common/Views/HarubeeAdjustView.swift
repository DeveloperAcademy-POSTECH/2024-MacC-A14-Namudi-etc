//
//  HarubeeAdjustView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared
import Domain

// MARK: - HarubeeAdjustView
struct HarubeeAdjustView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: HarubeeAdjustViewModel
  
  @State private var expression: String
  @State private var isUpdated: Bool = false
  @State private var isEnabled: Bool = false
  @State private var isAlert: Bool = false
  
  private let beforeHarubee: Int
  
  init(viewModel: HarubeeAdjustViewModel) {
    let initialHarubee = viewModel.state.dailyBudget.harubee ?? Int(viewModel.state.salaryBudget.defaultHarubee)
    self._viewModel = State(initialValue: viewModel)
    self.beforeHarubee = initialHarubee
    self._expression = State(initialValue: initialHarubee.decimal)
  }
  
  var body: some View {
    VStack {
      BottomSheetHeaderView(title: "하루비 조정")
      
      HarubeeAdjustBodyView(
        isUpdated: $isUpdated,
        defaultHarubee: viewModel.state.salaryBudget.defaultHarubee
      )
      .padding(.horizontal, 22)
      .padding(.top, 36)
      
      Spacer()
      
      AmountResultText(
        numberText: $expression
      ) {
        self.isUpdated = false
        self.isEnabled = false
        
        viewModel.send(.resetButtonTapped(beforeHarubee))
        self.expression = beforeHarubee.decimal
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
          
          viewModel.send(.doneButtonTapped(expression.numberFormat ?? 0))
        }
      }
    }
    .frame(maxWidth: .infinity)
    .ignoresSafeArea(edges: .bottom)
    .alert(
      "하루비 조정하기",
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
      Text("하루비를 \(expression)원으로 조정하시겠습니까?")
    }
  }
}

// MARK: - HarubeeAdjustBodyView
private struct HarubeeAdjustBodyView: View {
  
  @Binding private var isUpdated: Bool
  private var defaultHarubee: Double
  
  init(isUpdated: Binding<Bool>, defaultHarubee: Double) {
    self._isUpdated = isUpdated
    self.defaultHarubee = defaultHarubee
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      if isUpdated {
        Text("하루비 조정 후 계산된")
          .font(.pretendardMedium_18)
          .foregroundStyle(Color.textBlack)
          .padding(.top, 3)
      }
      
      HighlightDefaultHarubeeLabel(
        title: isUpdated ? "기본 하루비는" : "현재 기본 하루비는",
        amount: Int(defaultHarubee)
      )
      .padding(.top, isUpdated ? 6 : 0)
      
      if !isUpdated {
        VStack(alignment: .leading, spacing: 2) {
          Text("기본 하루비는 하루비 조정을 하지 않은 날짜에")
          Text("자동으로 분배되는 하루비를 의미해요")
        }
        .padding(.top, 14)
        .font(.pretendardMedium_14)
        .foregroundStyle(Color.textBlack30)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    
  }
}


// MARK: - HighlightDefaultHarubeeLabel
private struct HighlightDefaultHarubeeLabel: View {
  
  private let title: String
  private let amount: Int
  
  init(title: String, amount: Int) {
    self.title = title
    self.amount = amount
  }
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 0) {
      Text(title)
        .font(.pretendardMedium_18)
      
      Text(amount.decimalWithWon)
        .font(.pretendardSemibold_22)
        .padding(.leading, 6)
      
      Text("입니다")
        .font(.pretendardMedium_18)
    }
    .foregroundStyle(Color.textBlack)
  }
}

// MARK: - Preview
#Preview {
  HarubeeAdjustView(
    viewModel: DIContainer.shared.makeHarubeeAdjustViewModel(
      salaryBudget: SalaryBudget.default,
      dailyBudget: DailyBudget.default
    )
  )
}

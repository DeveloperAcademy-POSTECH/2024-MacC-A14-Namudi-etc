//
//  BalanceAdjustView.swift
//  Harubee-iOS
//
//  Created by 신승재 on 11/18/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - BalanceAdjustView
struct BalanceAdjustView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: BalanceAdjustViewModel
  
  @State private var realBalance: String // 변경할 실제 잔액
  @State private var isUpdated: Bool = false // 잔액이 변경되었는지 여부 확인
  
  @State private var isFocused: Bool = false
  
  private let beforeRealBalance: Int // 변경 전 실제 잔액
  
  init(viewModel: BalanceAdjustViewModel) {
    
    self._viewModel = State(initialValue: viewModel)
    
    let initialRealBalance = viewModel.state.realBalance
    
    self._realBalance = State(
      initialValue: initialRealBalance.decimalWithWon
    )
    
    self.beforeRealBalance = initialRealBalance
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        BottomSheetHeaderView(title: "쓸 수 있는 돈 조정")
        
        ZStack(alignment: .top) {
          ExpectedBalanceContentView(
            viewModel: viewModel, realBalance: $realBalance
          )
          .padding(.horizontal, 22)
          .padding(.top, 36)
          
          BalanceAdjustField(
            viewModel: viewModel,
            realBalance: $realBalance,
            isFocused: $isFocused
          )
          .padding(.top, 147)
          .padding(.horizontal, 20)
        }
        
        Spacer()
        
        MainColorBottomButton(
          title: "저장하기",
          isEnabled: $isUpdated
        ) {
          self.viewModel.send(.saveButtonTapped)
          self.dismiss()
        }
      }
      .frame(maxWidth: .infinity)
      
      if isFocused {
        NumberKeypadView(
          amount: $realBalance
        ) {
          self.isFocused = false
          
          viewModel
            .send(
              .doneButtonTapped(
                realBalance.numberFormat ?? 0
              )
            )
        }
      }
    }
    .onChange(of: isFocused) { _, _ in
      self.isUpdated = beforeRealBalance == realBalance.numberFormat ? false : true
    }
  }
}

// MARK: - ExpectedBalanceContentView
private struct ExpectedBalanceContentView: View {
  
  let viewModel: BalanceAdjustViewModel
  @Binding var realBalance: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      HStack(alignment: .bottom, spacing: 0) {
        Text("현재 쓸 수 있는 돈은")
          .font(.pretendardMedium_18)
        
        Text(
          "\((realBalance.numberFormat! - viewModel.state.totalFixedExpense).decimalWithWon)"
        )
          .font(.pretendardSemibold_22)
          .foregroundStyle(.main)
          .padding(.leading, 6)
        
        Text("입니다")
          .font(.pretendardMedium_18)
      }
      .foregroundStyle(Color.textBlack)
      
      VStack(alignment: .leading, spacing: 3) {
        Text("*쓸 수 있는 돈은 실제 잔액에서")
        HStack(spacing: 0) {
          Text("예정된 고정지출 \(viewModel.state.totalFixedExpense.decimalWithWon)")
            .background(
              Rectangle()
                .fill(.main10)
                .offset(y: 5)
                .frame(height: 10)
              
            )
          Text("을 뺀 금액입니다.")
        }
      }
      .padding(.top, 10)
      .font(.pretendardMedium_14)
      .foregroundStyle(Color.textBlack30)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

// MARK: - BalanceAdjustField
private struct BalanceAdjustField: View {
  @Environment(\.dismiss) private var dismiss
  
  let viewModel: BalanceAdjustViewModel
  @Binding var realBalance: String
  @Binding var isFocused: Bool
  
  var body: some View {
    VStack {
      FloatingTitleNumberField(
        title: "실제 잔액",
        textSize: .medium,
        text: $realBalance,
        isFocused: $isFocused
      )
      .onTapGesture {
        isFocused = true
      }
    }
  }
}

// MARK: - Preview
#Preview {
  BalanceAdjustView(
    viewModel: DIContainer.shared.makeBalanceAdjustViewModel(
      salaryBudget: SalaryBudget.default,
      dailyBudget: DailyBudget.default
    )
  )
}

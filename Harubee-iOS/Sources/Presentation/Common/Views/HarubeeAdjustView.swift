//
//  HarubeeAdjustView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - HarubeeAdjustView
struct HarubeeAdjustView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: HarubeeAdjustViewModel
  
  @State private var harubee: String // 변경할 하루비
  @State private var isUpdated: Bool = false // 하루비가 변경되었는지 여부 확인
  
  private let beforeHarubee: Int // 저장버튼 활성화 여부
  
  init(viewModel: HarubeeAdjustViewModel) {
    
    self._viewModel = State(initialValue: viewModel)
    
    let initialHarubee = viewModel.state.dailyBudget.harubee ?? Int(viewModel.state.salaryBudget.defaultHarubee)
    
    self._harubee = State(initialValue: initialHarubee.decimalWithWon)
    self.beforeHarubee = initialHarubee
  }
  
  var body: some View {
    VStack(spacing: 0) {
      BottomSheetHeaderView(title: "하루비 조정")
      
      HarubeeAdjustBodyView(
        isUpdated: $isUpdated,
        defaultHarubee: viewModel.state.salaryBudget.defaultHarubee
      )
      .padding(.horizontal, 22)
      .padding(.top, 36)
      
      FloatingTitleNumberField(
        title: "이 날의 하루비",
        text: $harubee,
        isFocused: .constant(true)
      )
      .padding(.top, 56)
      .padding(.horizontal, 20)
      
      Spacer()
      
      MainColorBottomButton(
        title: "저장하기",
        isEnabled: $isUpdated
      ) {
        self.viewModel.send(.saveButtonTapped)
        self.dismiss()
      }
      
      NumberKeypadView(amount: $harubee) {
//        self.isUpdated = beforeHarubee == harubee ? false : true
        
//        if isEnabled {
//          self.isUpdated = true
//          
//          viewModel.send(.doneButtonTapped(expression.numberFormat ?? 0))
//        }
      }
    }
    .frame(maxWidth: .infinity)
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
        VStack(alignment: .leading, spacing: 3) {
          Text("*기본 하루비는 하루비 조정을 하지 않은 날짜에")
          Text("자동으로 분배되는 하루비를 의미해요")
        }
        .padding(.top, 10)
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
        .foregroundStyle(.main)
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

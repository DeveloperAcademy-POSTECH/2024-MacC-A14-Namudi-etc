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
  
  @State private var isFocused: Bool = true
  
  private let beforeHarubee: Int // 변경 전 하루비
  
  init(viewModel: HarubeeAdjustViewModel) {
    
    self._viewModel = State(initialValue: viewModel)
    
    let initialHarubee = viewModel.state.updatedHarubee
    
    self._harubee = State(initialValue: initialHarubee.decimalWithWon)
    self.beforeHarubee = initialHarubee
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        ZStack(alignment: .top) {
          DefaultHarubeeContentView(
            isUpdated: $isUpdated,
            defaultHarubee: viewModel.state.defaultHarubee
          )
          .padding(.horizontal, 22)
          .padding(.top, 36)
          
          HarubeeAdjustField(
            viewModel: viewModel,
            harubee: $harubee,
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
        NumberKeypadView(amount: $harubee) {
          doneButtonTapped()
        }
      }
    }
    .navigationBarStyle(.sheet(title: "하루비 조정"))
  }
  
  private func doneButtonTapped() {
    self.isFocused = false
    
    // 변경된 하루비가 이전과 같지 않고, 0 이상인 경우 활성화
    let amount = harubee.numberFormat ?? 0
    self.isUpdated = (
      amount == beforeHarubee
      || amount < 0
    ) ? false : true
    
    if isUpdated {
      viewModel.send(.doneButtonTapped(harubee.numberFormat))
    }
  }
}

// MARK: - DefaultHarubeeContentView
private struct DefaultHarubeeContentView: View {
  
  @Binding private var isUpdated: Bool
  private var defaultHarubee: Int
  
  init(isUpdated: Binding<Bool>, defaultHarubee: Int) {
    self._isUpdated = isUpdated
    self.defaultHarubee = defaultHarubee
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      if isUpdated {
        Text("하루비 조정 후 계산된")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
          .padding(.top, 3)
      }
      
      highlightDefaultHarubeeLabel
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
  
  private var highlightDefaultHarubeeLabel: some View {
    HStack(alignment: .firstTextBaseline, spacing: 0) {
      Text(isUpdated ? "기본 하루비는" : "현재 기본 하루비는")
        .font(.pretendardSemibold_18)
      
      Text(defaultHarubee.decimalWithWon)
        .font(.pretendardSemibold_22)
        .foregroundStyle(.main)
        .padding(.leading, 4)
      
      Text("입니다")
        .font(.pretendardSemibold_18)
    }
    .foregroundStyle(Color.textBlack)
  }
}

// MARK: - HarubeeAdjustField
private struct HarubeeAdjustField: View {
  @Environment(\.dismiss) private var dismiss
  
  let viewModel: HarubeeAdjustViewModel
  @Binding var harubee: String
  @Binding var isFocused: Bool
  
  @State private var isAlert: Bool = false
  
  var body: some View {
    VStack {
      FloatingTitleNumberField(
        title: "이 날의 하루비",
        textSize: .large,
        text: $harubee,
        isFocused: $isFocused,
        minimum: .minimumZero
      )
      .overlay(alignment: .trailing, content: {
        resetHarubeeButton
      })
      
      .onTapGesture {
        isFocused = true
      }
    }
    .alert(
      "기본 하루비로 변경하시겠습니까?",
      isPresented: $isAlert) {
        Button {
          viewModel.send(.resetDoneButtonTapped)
          self.dismiss()
        } label: {
          Text("확인")
        }

        Button(role: .cancel) {
        } label: {
          Text("취소")
        }
      } message: {
        let defaultHarubee = viewModel.state.defaultHarubeeForAlert.decimalWithWon
        Text(
          """
          기본 하루비는 \(defaultHarubee)으로 저장됩니다.
          """
        )
      }

  }
  
  private var resetHarubeeButton: some View {
    HStack(spacing: 3) {
      Image(systemName: "arrow.clockwise")
        .font(.pretendardSemibold_14)
      Text("기본 하루비로 변경")
        .font(.pretendardMedium_14)
    }
    .foregroundStyle(.main)
    .padding(.horizontal, 8)
    .padding(.vertical, 6)
    .background(.whiteDeep)
    .clipShape(RoundedRectangle(cornerRadius: 5))
    .tapFeedback {
      viewModel.send(.resetButtonTapped)
      self.isAlert = true
    }
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

//
//  Onboarding3View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/1/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding3View: View {
  @Environment(OnboardingCoordinator.self) private var coordinator
  @Environment(OnboardingViewModel.self) private var viewModel
  
  @State private var isEnabled: Bool = false
  @State private var isFocused: Bool = false
  @State private var showDayPicker: Bool = false
  @State private var incomeDay: Int = 1
  @State private var incomeAmount: String = ""
  
  var body: some View {
    ZStack(alignment: .bottom) {
      
      Color.bgPrimary.ignoresSafeArea()
      
      VStack(spacing: 0) {
        OnboardingHeaderView()
        
        OnboardingBodyView(
          incomeDay: $incomeDay,
          incomeAmount: $incomeAmount,
          isFocused: $isFocused,
          showDayPicker: $showDayPicker
        )
        
        Spacer()
        
        MainColorBottomButton(
          title: "다음으로",
          isEnabled: $isEnabled
        ) {
          viewModel.send(.naviateToOnboardingStep3)
          coordinator.push(
            .onboarding4(
              currentBalanceAmount: viewModel.state.currentBalance?.decimalWithWon ?? ""
            )
          )
        }
      }
      
      if isFocused {
        NumberKeypadView(amount: $incomeAmount) {
          doneButtonTapped()
        }
      }
    }
    .navigationBarStyle(.onboarding, toolbar: {
      ToolbarItem(placement: .topBarTrailing) {
        Text("1/3")
          .font(.pretendardSemibold_22)
          .foregroundStyle(.textSecondaryInversion)
      }
    })
    .onChange(of: incomeDay, { _, _ in
      viewModel.send(.updateFixedIncomeDay(incomeDay))
    })
  }
  
  private func doneButtonTapped() {
    self.isFocused = false
    
    // 수입 금액이 입력된 상태이면서 0보다 큰 금액인 경우 활성화
    if !incomeAmount.isEmpty
        && incomeAmount.numberFormat ?? 0 > 0 {
      viewModel.send(.updateFixedIncomeAmount(
        incomeAmount.numberFormat ?? 0
      ))
      self.isEnabled = true
    } else {
      self.isEnabled = false
    }
  }
}

private struct OnboardingHeaderView: View {
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("먼저, 하루비를 계산하기 위한")
      Text("기본 정보를 입력해주세요")
    }
    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
    .font(.pretendardSemibold_24)
    .foregroundStyle(.textFixed)
    .padding(.horizontal, 20)
    .background(.bgAccent)
  }
}

private struct OnboardingBodyView: View {
  @Binding var incomeDay: Int
  @Binding var incomeAmount: String
  @Binding var isFocused: Bool
  @Binding var showDayPicker: Bool
  
  var body: some View {
    VStack(spacing: 30) {
      DayPickerView(
        title: "주요 수입일은 언제인가요?",
        titleFont: .onboarding,
        showDayPicker: $showDayPicker,
        selectedDay: $incomeDay
      )
      .padding(.top, 34)
      
      VStack(alignment: .leading, spacing: 0) {
        Text("한 달의 총 수입 금액은 얼마인가요?")
          .font(.pretendardMedium_20)
          .foregroundStyle(.textPrimary)
        
        Text("*입력하신 정보는 수입 기간 동안의 하루비를 계산할 때만 사용됩니다")
          .font(.pretendardMedium_12)
          .foregroundStyle(.textPrimary30)
          .padding(.top, 6)
        
        FloatingTitleNumberField(
          title: "금액",
          textSize: .medium,
          text: $incomeAmount,
          isFocused: $isFocused,
          minimum: .overZero
        )
        .onTapGesture {
          isFocused = true
          showDayPicker = false
        }
        .padding(.top, 16)
      }
    }
    .padding(.horizontal, 20)
    .onChange(of: showDayPicker) {
      if $1 { isFocused = false }
    }
  }
}

#Preview {
  NavigationStack {
    Onboarding3View()
      .environment(DIContainer.shared.makeOnboardingViewModel())
      .environment(OnboardingCoordinator())
  }
}

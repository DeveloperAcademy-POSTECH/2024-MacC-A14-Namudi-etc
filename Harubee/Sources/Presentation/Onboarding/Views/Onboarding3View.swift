//
//  Onboarding3View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/1/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding3View: View {
  private var viewModel: OnboardingViewModel
  
  @State private var isPresented: Bool = false
  @State private var isEnabled: Bool
  @State private var isFocused: Bool = false
  @State private var showDayPicker: Bool = false
  @State private var incomeDay: Int
  @State private var incomeAmount: String
  
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    self._incomeDay = .init(initialValue: viewModel.state.incomeDay)
    self._incomeAmount = .init(initialValue: viewModel.state.incomeAmount?.decimal ?? "")
    
    self._isEnabled = .init(initialValue: viewModel.state.incomeAmount == nil ? false : true)
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        onboardingHeaderView
        
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
          self.isPresented = true
        }
      }
      
      if isFocused {
        NumberKeypadView(amount: $incomeAmount) {
          self.isFocused = false
        }
      }
    }
    .onChange(of: incomeDay, { _, _ in
      viewModel.send(.updateFixedIncomeDay(incomeDay))
    })
    .onChange(of: incomeAmount, { _, _ in
      if !incomeAmount.isEmpty {
        viewModel.send(.updateFixedIncomeAmount(
          incomeAmount.numberFormat ?? 0
        ))
        self.isEnabled = true
      }
    })
    .navigationDestination(isPresented: $isPresented) {
      Onboarding4View(viewModel: viewModel)
        .navigationBarBackButtonHidden()
    }
  }
  
  private var onboardingHeaderView: some View {
    VStack(spacing: 30) {
      OnboardingNavigationHeaderView(onboardingPage: .first)
      
      VStack(alignment: .leading, spacing: 6) {
        Text("먼저, 하루비를 계산하기 위한")
        Text("기본 정보를 입력해주세요")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.pretendardSemibold_24)
      .foregroundStyle(Color.whiteDefault)
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 30)
    .background(
      Rectangle().fill(Color.main).ignoresSafeArea()
    )

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
        Text("한 달의 수입금은 얼마인가요?")
          .font(.pretendardMedium_20)
          .foregroundStyle(Color.textBlack)
        
        Text("*입력하신 정보는 수입 기간 동안의 하루비를 계산할 때만 사용됩니다")
          .font(.pretendardMedium_12)
          .foregroundStyle(Color.textBlack30)
          .padding(.top, 6)
        
        FloatingTitleNumberField(
          title: "금액",
          textSize: .medium,
          text: $incomeAmount,
          isFocused: $isFocused
        )
        .onTapGesture {
          isFocused = true
          showDayPicker = false
        }
        .padding(.top, 16)
      }
      .padding(.horizontal, 20)
    }
    .onChange(of: incomeAmount) { _, _ in
      incomeAmount = (incomeAmount.numberFormat ?? 0).decimal
    }
    .onChange(of: showDayPicker) {
      if $1 { isFocused = false }
    }
  }
}

#Preview {
  Onboarding3View(viewModel: DIContainer.shared.makeOnboardingViewModel())
}

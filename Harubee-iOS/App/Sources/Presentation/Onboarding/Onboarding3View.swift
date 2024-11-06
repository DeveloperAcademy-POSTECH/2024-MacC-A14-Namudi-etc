//
//  Onboarding3View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/1/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct Onboarding3View: View {
  @Environment(OnboardingViewModel.self) private var viewModel
  
  @State private var isPresented: Bool = false
  @State private var isEnabled: Bool = false
  @State private var incomeDay: Int = 1
  @State private var incomeAmount: String = ""
  
  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView()
      
      OnboardingBodyView(incomeDay: $incomeDay, incomeAmount: $incomeAmount)
      
      Spacer()
      
      MainColorButton(title: "다음으로", isEnabled: $isEnabled) {
        viewModel.send(.nextButtonTapped(
          incomeDay: incomeDay,
          incomeAmount: incomeAmount.numberFormat)
        )
        self.isPresented = true
      }
      .clipShape(
        RoundedRectangle(cornerRadius: 10)
      )
      .padding(.horizontal, 16)
      .padding(.bottom, 9)
    }
    .onTapGesture {
      UIApplication.shared.endEditing()
    }
    .onChange(of: incomeAmount, { _, _ in
      self.isEnabled = true
    })
    .navigationDestination(isPresented: $isPresented) {
      Onboarding4View()
        .navigationBarBackButtonHidden()
    }
  }
}

private struct OnboardingHeaderView: View {
  var body: some View {
    VStack(spacing: 28) {
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
  
  @Binding private var incomeDay: Int
  @Binding private var incomeAmount: String
  
  init(incomeDay: Binding<Int>, incomeAmount: Binding<String>) {
    self._incomeDay = incomeDay
    self._incomeAmount = incomeAmount
  }
  
  var body: some View {
    VStack(spacing: 30) {
      DayPickerView(
        title: "주요 수입일은 언제인가요?",
        titleFont: .onboarding,
        selectedDay: $incomeDay
      )
      .padding(.top, 34)
      
      VStack(alignment: .leading, spacing: 0) {
        Text("한 달의 수입금은 얼마인가요?")
          .font(.pretendardMedium_20)
          .foregroundStyle(Color.textBlack)
        
        Text("*입력하신 정보는 수입 기간동안의 하루비를 계산할 때만 사용됩니다")
          .font(.pretendardMedium_12)
          .foregroundStyle(Color.textBlack30)
          .padding(.top, 6)
        
        FloatingTitleTextField(
          title: "금액",
          text: $incomeAmount
        )
        .padding(.top, 24)
        .keyboardType(.numberPad)
      }
      .padding(.horizontal, 20)
      
    }
    .onChange(of: incomeAmount) { oldValue, newValue in
      incomeAmount = (incomeAmount.numberFormat ?? 0).decimal
    }
  }
}

#Preview {
  Onboarding3View()
    .environment(DIContainer.shared.makeOnboardingViewModel())
}

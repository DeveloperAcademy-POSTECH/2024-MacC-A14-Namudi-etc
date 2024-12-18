//
//  Onboarding4View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding4View: View {
  // TODO: Environment로 전달 받기
  let viewModel: OnboardingViewModel
  
  @State var currentBalanceAmount: String
  @State private var isEnabled: Bool = true
  @State private var isFocused: Bool = true
  @State private var isPresented: Bool = false
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        OnboardingHeaderView(
          averageHarubee: viewModel.state.averageHarubee
        )
        
        OnboardingBodyView(
          startDate: viewModel.state.incomeStartDate,
          currentBalance: $currentBalanceAmount,
          isFocused: $isFocused
        )
        
        MainColorBottomButton(
          title: "다음으로",
          isEnabled: $isEnabled
        ) {
          self.isPresented = true
        }
      }
      
      if isFocused {
        NumberKeypadView(amount: $currentBalanceAmount) {
          doneButtonTapped()
        }
      }
    }
    .navigationDestination(isPresented: $isPresented) {
      Onboarding5View(
        viewModel: viewModel,
        fixedExpenses: viewModel.state.fixedExpenses
      )
        .navigationBarBackButtonHidden()
    }
  }
  
  private func doneButtonTapped() {
    self.isFocused = false
    if !currentBalanceAmount.isEmpty
        && currentBalanceAmount.numberFormat ?? 0 >= 0 {
      viewModel.send(.updateCurrentBalance(
        currentBalanceAmount.numberFormat ?? 0
      ))
      self.isEnabled = true
    } else {
      self.isEnabled = false
    }
  }
}

private struct OnboardingHeaderView: View {
  let averageHarubee: Int
  
  var body: some View {
    VStack(spacing: 28) {
      OnboardingNavigationHeaderView(onboardingPage: .second)
      
      VStack(alignment: .leading, spacing: 6) {
        Text("현재 하루비는")
        
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          Text(averageHarubee.decimalWithWon)
            .font(.pretendardSemibold_30)
          Text("입니다")
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.pretendardSemibold_24)
      .foregroundStyle(Color.whiteDefault)
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 23)
    .background(
      Rectangle().fill(Color.main).ignoresSafeArea()
    )
  }
}

private struct OnboardingBodyView: View {
  let startDate: Date
  
  @Binding var currentBalance: String
  @Binding var isFocused: Bool
  
  private var dateString: String {
    startDate.formattedDateToString(.monthDay_kr)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text("현재 잔액은 얼마인가요?")
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.pretendardMedium_20)
        .foregroundStyle(Color.textBlack)
        .padding(.horizontal, 20)
      
      VStack(alignment: .leading, spacing: 2) {
        Text("*신용카드 사용 등의 이유로 잔액 파악이 어렵다면")
        Text("수입금에서 지출 금액을 빼서 계산하는 방법도 있어요!")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(Color.textBlack30)
      .font(.pretendardMedium_12)
      .padding(.top, 6)
      .padding(.horizontal, 20)
      
      FloatingTitleNumberField(
        title: "금액",
        textSize: .medium,
        text: $currentBalance,
        isFocused: $isFocused,
        minimum: .minimumZero
      )
      .onTapGesture {
        isFocused = true
      }
      .padding(.horizontal, 16)
      .padding(.top, 32)
    }
    .padding(.top, 30)
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

#Preview {
  Onboarding4View(
    viewModel: DIContainer.shared.makeOnboardingViewModel(),
    currentBalanceAmount: ""
  )
}

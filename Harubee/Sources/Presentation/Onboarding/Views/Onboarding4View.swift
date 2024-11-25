//
//  Onboarding4View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding4View: View {
  private var viewModel: OnboardingViewModel
  
  @State private var previousExpenseAmount: String
  
  @State private var isEnabled: Bool
  @State private var isFocused: Bool = false
  @State private var isPresented: Bool = false
  
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    self._previousExpenseAmount = .init(initialValue: viewModel.state.previousExpense?.decimal ?? "")
    
    self._isEnabled = .init(initialValue: viewModel.state.previousExpense == nil ? false : true)
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        OnboardingHeaderView(
          averageHarubee: viewModel.state.averageHarubee
        )
        
        OnboardingBodyView(
          startDate: viewModel.state.incomeStartDate,
          expenseAmount: $previousExpenseAmount,
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
        NumberKeypadView(amount: $previousExpenseAmount) {
          self.isFocused = false
          if !previousExpenseAmount.isEmpty {
            
            viewModel.send(.updatePreviousExpense(
              previousExpenseAmount.numberFormat ?? 0
            ))
            
            self.isEnabled = true
          }
        }
      }
    }
    .navigationDestination(isPresented: $isPresented) {
      Onboarding5View(viewModel: viewModel)
        .navigationBarBackButtonHidden()
    }
  }
}

private struct OnboardingHeaderView: View {
  private let averageHarubee: Int
  
  init(averageHarubee: Int) {
    self.averageHarubee = averageHarubee
  }
  
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
  @Binding var expenseAmount: String
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
      
      FloatingTitleNumberField(
        title: "금액",
        textSize: .medium,
        text: $expenseAmount,
        isFocused: $isFocused
      )
      .onTapGesture {
        isFocused = true
      }
      .padding(.horizontal, 16)
      .padding(.top, 16)
      
      
      VStack(alignment: .leading, spacing: 2) {
        Text("*신용카드 사용 등의 이유로 잔액 파악이 어렵다면")
        Text("수입금에서 지출 금액을 빼서 계산하는 방법도 있어요!")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(Color.textBlack30)
      .font(.pretendardMedium_12)
      .padding(.top, 10)
      .padding(.horizontal, 20)
      
    }
    .padding(.top, 30)
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

#Preview {
  Onboarding4View(viewModel: DIContainer.shared.makeOnboardingViewModel())
}

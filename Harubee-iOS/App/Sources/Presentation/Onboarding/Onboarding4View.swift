//
//  Onboarding4View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct Onboarding4View: View {
  private var viewModel: OnboardingViewModel
  
  @State private var previousExpenseAmount: String
  
  @State private var isEnabled: Bool
  @State private var isPresented: Bool = false
  
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    self._previousExpenseAmount = .init(initialValue: viewModel.state.previousExpense?.decimal ?? "")
    
    self._isEnabled = .init(initialValue: viewModel.state.previousExpense == nil ? false : true)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView(
        averageHarubee: viewModel.state.averageHarubee
      )
      
      OnboardingBodyView(
        startDate: viewModel.state.incomeStartDate,
        expenseAmount: $previousExpenseAmount
      )
      
      
      MainColorButton(title: "다음으로", isEnabled: $isEnabled, cornerRadius: 0) {
        self.isPresented = true
      }
      
      NumberKeypadView(expression: $previousExpenseAmount) { isEnabled in
        if isEnabled {
          viewModel.send(.updatePreviousExpense(previousExpenseAmount.numberFormat ?? 0))
        }
        
        self.isEnabled = isEnabled
      }
      .padding(.top, 26)
      .padding(.horizontal, 16)
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
  @Binding private var expenseAmount: String
  
  private let startDate: String
  
  init(startDate: Date, expenseAmount: Binding<String>) {
    self.startDate = startDate.formattedDateToString(.Md)
    self._expenseAmount = expenseAmount
  }
  
  var body: some View {
    VStack(spacing: 30) {
      VStack(alignment: .leading, spacing: 6) {
        Text("\(startDate)부터 오늘까지")
        Text("얼마를 사용하셨나요?")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.pretendardMedium_20)
      .foregroundStyle(Color.textBlack)
      .padding(.horizontal, 20)
      
      VStack(alignment: .leading, spacing: 0) {
        
        Text("지출 금액")
          .font(.pretendardMedium_12)
          .foregroundStyle(expenseAmount.isEmpty ? .clear : Color.main)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 4)
          .offset(y: !expenseAmount.isEmpty ? -4 : 0)
          .animation(.easeOut(duration: 0.2), value: !expenseAmount.isEmpty)
        
        Text(expenseAmount.isEmpty ? "지출 금액" : expenseAmount)
          .font(.pretendardMedium_18)
          .foregroundStyle(expenseAmount.isEmpty ? Color.textBrighter : Color.textBlack)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 4)
        
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(expenseAmount.isEmpty ? Color.textBrighter : Color.main)
          .padding(.top, 8)
        
        Text("*계산이 어렵다면 수입금에서 잔액을 빼서 계산하는 방법도 있어요!")
          .foregroundStyle(Color.textBlack30)
          .font(.pretendardMedium_12)
          .padding(.top, 6)
          .padding(.horizontal, 4)
      }
      .padding(.horizontal, 16)
    }
    .padding(.top, 30)
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

#Preview {
  Onboarding4View(viewModel: DIContainer.shared.makeOnboardingViewModel())
}

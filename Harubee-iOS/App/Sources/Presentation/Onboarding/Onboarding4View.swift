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
  @Environment(OnboardingViewModel.self) private var viewModel
  
  @State private var previousExpenseAmount: String = ""
  
  @State private var isEnabled: Bool = false
  @State private var isPresented: Bool = false
  
  var body: some View {
    
      VStack(spacing: 0) {
        OnboardingHeaderView(
          averageHarubee: viewModel.state.averageHarubee
        )
        
        OnboardingBodyView(
          startDate: viewModel.state.incomeStartDate,
          expenseAmount: $previousExpenseAmount
        )
        
        
        MainColorButton(title: "다음으로", isEnabled: $isEnabled) {
          viewModel.send(.nextButtonTapped(
            previousExpense: previousExpenseAmount.numberFormat
          ))
          
          self.isPresented = true
        }
        
        NumberKeypadView(expression: $previousExpenseAmount) { isEnabled in
          self.isEnabled = isEnabled
        }
        .padding(.top, 26)
        .padding(.horizontal, 16)
      }
      .onAppear {
        viewModel.send(.onAppear)
      }
      .navigationDestination(isPresented: $isPresented) {
        Onboarding5View()
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
      
      VStack(spacing: 0) {
        
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
      }
      .padding(.horizontal, 16)
    }
    .padding(.top, 30)
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

#Preview {
  Onboarding4View()
    .environment(DIContainer.shared.makeOnboardingViewModel())
}

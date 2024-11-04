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
  @State private var expenseAmount: String = ""
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        OnboardingHeaderView()
        
        OnboardingBodyView(expenseAmount: $expenseAmount)
      }
      ButtonKeyboardView(expenseAmount: $expenseAmount)
    }
  }
}

private struct OnboardingHeaderView: View {
  var body: some View {
    VStack(spacing: 28) {
      OnboardingNavigationHeaderView(onboardingPage: .second)
      
      VStack(alignment: .leading, spacing: 6) {
        Text("현재 하루비는")
        HStack(alignment: .bottom, spacing: 0) {
          Text("0원")
            .font(.pretendardSemibold_30)
          Text("입니다")
            .padding(.bottom, 1)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.pretendardSemibold_24)
      .foregroundStyle(Color.whiteDefault)
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 26)
    .background(
      Rectangle().fill(Color.main).ignoresSafeArea()
    )
  }
}

private struct OnboardingBodyView: View {
  @Binding var expenseAmount: String
  
  var body: some View {
    VStack(spacing: 30) {
      VStack(alignment: .leading, spacing: 6) {
        Text("9월 15일부터 오늘까지")
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

private struct ButtonKeyboardView: View {
  @Binding var expenseAmount: String
  
  var body: some View {
    // TODO: NumberKeypadView와 MainColorButton의 padding이 .. 불확실함 ㅠ
    VStack(spacing: 20) {
      MainColorButton(title: "다음으로") {
        print("다음으로")
      }
      
      NumberKeypadView(text: $expenseAmount)
    }
    .frame(maxHeight: .infinity, alignment: .bottom)
  }
}


#Preview {
  Onboarding4View()
}

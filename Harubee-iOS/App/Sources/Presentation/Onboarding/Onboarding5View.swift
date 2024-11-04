//
//  Onboarding5View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct Onboarding5View: View {
  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView()
      
      OnboardingBodyView()

      MainColorButton(title: "다음으로") {
        print("onboarding 5 to 6")
      }
      .clipShape(
        RoundedRectangle(cornerRadius: 10)
      )
      .padding(.horizontal, 16)
      .padding(.bottom, 9)
    }
  }
}

private struct OnboardingHeaderView: View {
  var body: some View {
    VStack(spacing: 28) {
      OnboardingNavigationHeaderView(onboardingPage: .third)
      
      VStack(alignment: .leading, spacing: 6) {
        Text("현재 계산된 하루비는")
        HStack(spacing: 0) {
          Image(systemName: "exclamationmark.triangle.fill")
            .resizable()
            .frame(width: 20, height: 20)
          HStack(alignment: .bottom, spacing: 0) {
            Text("100,000원")
              .padding(.leading, 6)
              .font(.pretendardSemibold_28)
            Text("입니다")
              .padding(.bottom, 1)
          }
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
  
  var body: some View {
    VStack(spacing: 30) {
      VStack(alignment: .leading, spacing: 6) {
        Text("매달 고정으로 나가는 지출 내역을")
        Text("입력해주세요 (예: 월세, 구독비, 저축)")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.pretendardMedium_20)
      .foregroundStyle(Color.textBlack)
      .padding(.horizontal, 20)
      
      FixedExpenseListView()
    }
    .padding(.top, 30)
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

#Preview {
  Onboarding5View()
}

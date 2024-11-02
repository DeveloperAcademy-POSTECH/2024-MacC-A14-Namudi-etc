//
//  Onboarding4View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct Onboarding4View: View {
  @State private var expenseAmount: String = ""
  
  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView()
        .padding(.top, 83)
        .padding(.bottom, 26)
        .background(
          Rectangle()
            .fill(Color.main)
        )
      OnboardingBodyView(expenseAmount: $expenseAmount)
      
    }
    .ignoresSafeArea()
  }
}

private struct OnboardingHeaderView: View {
  var body: some View {
    VStack(spacing: 28) {
      NavigationHeaderView(pageNumber: .second)
      
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
      
      FloatingTitleTextField(title: "지출 금액",
                             text: $expenseAmount
      )
      .padding(.horizontal, 16)
      
      Spacer()
      
      Button {
        
      } label: {
        Text("다음으로")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.whiteDeep)
          .padding(.horizontal, 149)
          .padding(.vertical, 20)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.main)
            // textfield 다 안 채워지면 Main_30
          )
      }
      .padding(.bottom, 43)
    }
    .padding(.top, 30)
    .frame(maxHeight: .infinity, alignment: .top)
  }
}


#Preview {
  Onboarding4View()
}

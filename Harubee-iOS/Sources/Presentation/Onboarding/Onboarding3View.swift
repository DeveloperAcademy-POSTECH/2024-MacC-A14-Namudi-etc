//
//  Onboarding3View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/1/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct Onboarding3View: View {
  @State private var selectedDay: Int = 1
  @State private var fixedIncomeAmount: String = ""
  
  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView()
        .padding(.top, 83)
        .padding(.bottom, 33)
        .background(
          Rectangle()
            .fill(Color.main)
        )
      OnboardingBodyView(selectedDay: $selectedDay, fixedIncomeAmount: $fixedIncomeAmount)
      
    }
    .ignoresSafeArea()
  }
}

private struct OnboardingHeaderView: View {
  var body: some View {
    VStack(spacing: 26) {
      NavigationHeaderView(pageNumber: .first)
      
      VStack(alignment: .leading, spacing: 6) {
        Text("먼저, 하루비를 계산하기 위한")
        Text("기본 정보를 입력해주세요")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.pretendardSemibold_24)
      .foregroundStyle(Color.whiteDefault)
    }
    .padding(.horizontal, 20)
  }
}

private struct OnboardingBodyView: View {
  @Binding var selectedDay: Int
  @Binding var fixedIncomeAmount: String
  
  var body: some View {
    VStack(spacing: 30) {
      DayPickerView(title: "주요 수입일은 언제인가요?",
                    titleFont: .onboarding,
                    selectedDay: $selectedDay
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
        
        FloatingTitleTextField(title: "금액", text: $fixedIncomeAmount)
          .padding(.top, 24)
      }
      .padding(.horizontal, 20)
      
      Spacer()
      
      Button {
        
      } label: {
        Text("저장하기")
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
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

#Preview {
  Onboarding3View()
}

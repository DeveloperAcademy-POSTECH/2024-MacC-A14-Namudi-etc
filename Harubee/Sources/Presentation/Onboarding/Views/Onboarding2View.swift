//
//  Onboarding2View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/1/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding2View: View {
  @Environment(OnboardingViewModel.self) private var viewModel
  @State private var isPresented: Bool = false
  
  var body: some View {
    ZStack {
      Color.main.ignoresSafeArea()
      VStack(spacing: 0) {
        titleView
        
        harubeeExplainView
        .padding(.horizontal, 16)
        .padding(.top, 12)
        
        calculateContentView
          .padding(.top, 73)
          .padding(.horizontal, 16)
        Spacer()
        
        MainColorBottomButton(
          title: "다음으로",
          isReverseColor: true) {
            isPresented = true
          }
      }
      .frame(maxHeight: .infinity, alignment: .top)
      .padding(.top, 76)
      .navigationDestination(isPresented: $isPresented) {
        Onboarding3View()
          .navigationBarBackButtonHidden()
      }
    }
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 4) {
        Image(.harubeeWhite)
          .resizable()
          .frame(width: 26, height: 26)
        Text("내가 하루에 얼마를")
          .font(.pretendardSemibold_30)
      }
      Text("쓸 수 있을까?")
        .font(.pretendardSemibold_30)
    }
    .foregroundStyle(Color.whiteDefault)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
  
  private var harubeeExplainView: some View {
    VStack(spacing: 22) {
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
      VStack(alignment: .leading, spacing: 8) {
        Text("하루비는 다음 수입일까지")
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.whiteDeep50)
        HStack(spacing: 3) {
          Text("하루에 쓸 수 있는 금액을 미리 알려주는 앱")
            .foregroundStyle(Color.whiteDefault)
            .highlighter(.mainBrighter15)
          Text("이에요")
            .foregroundStyle(Color.whiteDeep50)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 4)
    }
  }
  
  private var calculateContentView: some View {
    VStack(spacing: 0) {
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
        .padding(.horizontal, 4)
      
      Text("하루비의 계산 방법은 아래와 같아요")
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.whiteDeep50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 4)
        .padding(.top, 22)
      
      Text("(잔액 - 예정된 고정지출) ÷ 다음 주요 수입일까지 남은 일수")
        .font(.pretendardSemibold_14)
        .foregroundStyle(.whiteDefault)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(.mainBrighter10)
        )
        .padding(.top, 12)
    }
  }
}

#Preview {
  Onboarding2View()
    .environment(DIContainer.shared.makeOnboardingViewModel())
}

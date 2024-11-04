//
//  Onboarding6View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct Onboarding6View: View {
  var body: some View {
    ZStack {
      Color.main.ignoresSafeArea()
      VStack(spacing: 0) {
        TitleView()
          .padding(.top, 76)
          .padding(.horizontal, 4)
        
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 12)
        
        CurrentHarubeeView()
          .padding(.top, 36)
        
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 28)
        
        UserInfoView()
          .padding(.top, 26)
          .padding(.horizontal, 4)
        
        Spacer()
        
        OnboardingFooterView()
          .padding(.bottom, 9)
      }
      .frame(maxWidth: .infinity, alignment: .top)
      .padding(.horizontal, 16)
    }
  }
}

private struct TitleView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("모든 단계가")
      Text("끝났어요!")
    }
    .font(.pretendardSemibold_30)
    .foregroundStyle(Color.whiteDefault)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct CurrentHarubeeView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("현재 계산된 하루비")
        .font(.pretendardSemibold_22)
        .padding(.horizontal, 4)
      
      HStack(alignment: .bottom, spacing: 4) {
        Image(systemName: "exclamationmark.triangle.fill")
          .resizable()
          .frame(width: 24, height: 24)
          .padding(.bottom, 5)
        Text("6,000원")
          .font(.pretendardSemibold_30)
      }
      .padding(.horizontal, 4)
      
      Text("(나의 수입 - 고정지출) ÷ 다음 주요 수입일까지 남은 일수")
        .font(.pretendardSemibold_14)
        .foregroundStyle(Color.whiteDefault)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
          RoundedRectangle(cornerRadius: 10)
          // TODO: 추가된 색상으로 변경 필요
            .fill(Color.black)
        )
        .padding(.top, 36)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .foregroundStyle(Color.whiteDefault)
  }
}

private struct UserInfoView: View {
  var body: some View {
    VStack(spacing: 12) {
      UserInfoItemView(title: "한 달 수입금", content: "1,000,000원")
      UserInfoItemView(title: "수입일(9월 15일) 이후 지출한 금액", content: "- 300,000원")
      UserInfoItemView(title: "고정 지출 (총 7건)", content: "- 120,000원")
      UserInfoItemView(title: "다음 수입일까지 남은 기간", content: "÷ 15일")
    }
  }
}

private struct UserInfoItemView: View {
  private var title: String
  private var content: String
  
  init(title: String, content: String) {
    self.title = title
    self.content = content
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Text(title)
        .font(.pretendardMedium_14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Color.whiteDeep50)
      Text(content)
        .font(.pretendardSemibold_14)
        .foregroundStyle(Color.whiteDefault)
    }
  }
}

private struct OnboardingFooterView: View {
  var body: some View {
    VStack(spacing: 0) {
      Text("입력한 정보들은 설정에서 언제든지 수정할 수 있어요")
        .font(.pretendardMedium_12)
        .foregroundStyle(Color.whiteDeep50)
      
      MainColorButton(title: "하루비 시작하기") {
        print("harubee start")
      }
    }
  }
}

#Preview {
  Onboarding6View()
}

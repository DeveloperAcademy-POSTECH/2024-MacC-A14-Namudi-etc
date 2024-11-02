//
//  Onboarding6View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

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
          .padding(.horizontal, 4)
        
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 36)
        
        UserInfoView()
          .padding(.top, 16)
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
      
      HStack(alignment: .bottom, spacing: 4) {
        Image(systemName: "exclamationmark.triangle.fill")
          .resizable()
          .frame(width: 24, height: 24)
          .padding(.bottom, 5)
        Text("6,000원")
          .font(.pretendardSemibold_30)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .foregroundStyle(Color.whiteDefault)
  }
}

private struct UserInfoView: View {
  var body: some View {
    VStack(spacing: 12) {
      UserInfoItemView(title: "주요 수입일", content1: "매달 10일")
      UserInfoItemView(title: "한 달 수입금", content1: "1,000,000원")
      UserInfoItemView(title: "수입일(9월 15일) 이후 지출한 금액", content1: "1,000,000원")
      UserInfoItemView(title: "고정 지출", content1: "총 7건,", content2: " 120,000원")
    }
  }
}

private struct UserInfoItemView: View {
  private var title: String
  private var content1: String
  private var content2: String?
  
  init(title: String, content1: String, content2: String? = nil) {
    self.title = title
    self.content1 = content1
    self.content2 = content2
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Text(title)
        .font(.pretendardMedium_14)
        .frame(maxWidth: .infinity, alignment: .leading)
      Text(content1)
        .font(.pretendardSemibold_14)
        .padding(.trailing, content2 != nil ? -2 : 0)
      Text(content2 ?? "")
        .font(.pretendardSemibold_14)
    }
    .foregroundStyle(Color.whiteDefault)
  }
}

private struct OnboardingFooterView: View {
  var body: some View {
    VStack(spacing: 0) {
      Text("입력한 정보들은 설정에서 언제든지 수정할 수 있어요")
        .font(.pretendardMedium_12)
        .foregroundStyle(Color.whiteDeep50)
      
      Button {
        
      } label: {
        Text("하루비 시작하기")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.whiteDeep)
          .padding(.horizontal, 100)
          .padding(.vertical, 20)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.main)
            // textfield 다 안 채워지면 Main_30
          )
      }
    }
  }
}

#Preview {
  Onboarding6View()
}

//
//  Onboarding2View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/1/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct Onboarding2View: View {
  var body: some View {
    ZStack {
      Color.main.ignoresSafeArea()
      VStack(spacing: 0) {
        TitleView()
        
        HarubeeExplainView()
        .padding(.horizontal, 16)
        .padding(.top, 12)
        
        CalculateContentView()
          .padding(.top, 73)
          .padding(.horizontal, 16)
        Spacer()
        
        MainColorButton(title: "다음으로") {
          print("onboarding 3 to 4")
        }
        .padding(.bottom, 9)
      }
      .frame(maxHeight: .infinity, alignment: .top)
      .padding(.top, 76)
    }
  }
}

private struct TitleView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 4) {
        // TODO: 앱 아이콘으로 변경 필요
        Image(systemName: "exclamationmark.triangle.fill")
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
}

private struct HarubeeExplainView: View {
  var body: some View {
    VStack(spacing: 22) {
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
      VStack(alignment: .leading, spacing: 8) {
        Text("하루비는 다음 수입일까지")
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.whiteDeep50)
          .padding(.leading, 4)
        HStack(spacing: 3) {
          ZStack(alignment: .bottom) {
            Text("하루에 쓸 수 있는 금액을 미리 알려주는 앱")
              .padding(.horizontal, 4)
              .foregroundStyle(Color.whiteDefault)
              .background(
                Rectangle()
                // TODO: 추가되는 색상으로 수정 필요
                  .fill(Color.blue)
                  .frame(height: 7)
                  .offset(y: 8)
              )
          }
          Text("이에요")
            .foregroundStyle(Color.whiteDeep50)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

private struct CalculateContentView: View {
  var body: some View {
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
        .padding(.top, 12)
    }
  }
}

#Preview {
  Onboarding2View()
}

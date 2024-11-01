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
        TextContentView(content1: "하루비는 다음 수입일까지",
                        content2: "하루에 쓸 수 있는 금액을 미리 알려주는 앱",
                        content3: "이에요"
        )
        .padding(.top, 12)
        TextContentView(content1: "하루비의 계산 방법은 아래와 같아요")
          .padding(.top, 73)
        CalculateContentView()
          .padding(.top, 12)
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

private struct TextContentView: View {
  private var content1: String
  private var content2: String?
  private var content3: String?
  
  init(content1: String,
       content2: String? = nil,
       content3: String? = nil
  ) {
    self.content1 = content1
    self.content2 = content2
    self.content3 = content3
  }
  
  var body: some View {
    VStack(spacing: 22) {
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
        .padding(.leading,
                 content2 == nil || content3 == nil ? 4 : 0
        )
      
      VStack(alignment: .leading, spacing: 8) {
        Text(content1)
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.whiteDeep50)
          .padding(.leading, 4)
        
        if !(content2 == nil && content3 == nil) {
          HStack(spacing: 3) {
            ZStack(alignment: .bottom) {
              Text(content2 ?? "")
                .padding(.horizontal, 4)
                .foregroundStyle(content2 == nil ? .clear : Color.whiteDefault)
                .background(
                  Rectangle()
                  // TODO: 추가되는 색상으로 수정 필요
                    .fill(content2 == nil ? .clear : Color.blue)
                    .frame(height: 7)
                    .offset(y: 8)
                )
            }
            Text(content3 ?? "")
              .foregroundStyle(content2 == nil || content3 == nil
                               ? .clear
                               : Color.whiteDeep50
              )
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 16)
  }
}

private struct CalculateContentView: View {
  var body: some View {
    Text("(나의 수입 - 고정지출) ÷ 다음 주요 수입일까지 남은 일수")
      .font(.pretendardSemibold_14)
      .foregroundStyle(Color.whiteDefault)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(
        RoundedRectangle(cornerRadius: 10)
        // TODO: 추가된 색상으로 변경 필요
          .fill(Color.black)
          .padding(.horizontal, 16)
      )
  }
}

#Preview {
  Onboarding2View()
}

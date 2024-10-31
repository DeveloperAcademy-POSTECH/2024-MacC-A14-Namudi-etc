//
//  SettingView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct SettingView: View {
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.textBlack5.edgesIgnoringSafeArea(.bottom)
      VStack(spacing: 6) {
        SectionContainer {
          SettingItem(title: "고정지출 관리", previewText: "총 8건 / 120,000원")
          SettingItem(title: "고정수입 관리", previewText: "매달 12일 / 1,300,000원")
        }
      }
    }
    .navigationBarTitle("설정")
    .font(.pretendardMedium_18)
    .foregroundStyle(Color.textBlack)
  }
}

private struct SettingItem: View {
  
  private let title: String
  private let previewText: String
  
  init(title: String, previewText: String) {
    self.title = title
    self.previewText = previewText
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 8) {
      Text(title)
        .font(.pretendardSemibold_18)
        .foregroundStyle(Color.textBlack)
      
      Spacer()
      
      Text(previewText)
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.main)
      
      Image(systemName: "chevron.right")
        .font(Font.system(size: 16, weight: .regular))
        .foregroundStyle(Color.textBlack)
        .frame(width: 12, height: 19)
    }
  }
}


// MARK: - SectionContainer
private struct SectionContainer<Content: View>: View {
  private let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 34) {
      content()
    }
    .padding(EdgeInsets(top: 32,
                        leading: 18,
                        bottom: 32,
                        trailing: 18))
    .frame(maxWidth: .infinity)
    .background(Color.whiteDefault)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 1)
  }
}

#Preview {
  SettingView()
}

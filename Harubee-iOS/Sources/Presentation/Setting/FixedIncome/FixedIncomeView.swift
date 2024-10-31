//
//  FixedIncomeView.swift
//  Data
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FixedIncomeView: View {
  var body: some View {
    HeaderView()
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(spacing: 4) {
      VStack(alignment: .leading, spacing: 10) {
        Text("고정수입 날짜를 기준으로")
        Text("하루비를 알려드릴게요.")
      }
      .foregroundStyle(Color.textBlack)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 6)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
    }
    .font(.pretendardSemibold_22)
    .padding(.horizontal, 16)
  }
}

#Preview {
  FixedIncomeView()
}

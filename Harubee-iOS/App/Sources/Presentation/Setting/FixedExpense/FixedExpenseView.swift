//
//  FixedExpensesView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct FixedExpenseView: View {
  @State private var mode: Mode = .add
  var body: some View {
    VStack(spacing: 0) {
      HeaderView()
      FixedExpenseListView()
        .padding(.top, 33)
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(spacing: 12) {
      VStack(spacing: 10) {
        Text("총 0건")
        Text("총 0원")
      }
      .font(.pretendardSemibold_24)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 26)
      .padding(.top, 44)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
        .padding(.horizontal, 18)
    }
  }
}



#Preview {
  FixedExpenseView()
}

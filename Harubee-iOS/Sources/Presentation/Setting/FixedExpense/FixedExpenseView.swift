//
//  FixedExpensesView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FixedExpenseView: View {
  var body: some View {
    VStack(spacing: 0) {
      HeaderView()
      BodyView()
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 10) {
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
        .padding(.top, 12)
    }
  }
}

private struct BodyView: View {
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("내역")
          .font(.pretendardSemibold_16)
        
        Spacer()
        
        Button {
          
        } label: {
          Image(systemName: "plus")
            .frame(width: 19, height: 21)
        }
      }
      .foregroundStyle(Color.textBlack)
      .padding(.leading, 22)
      .padding(.trailing, 18)
      .padding(.top, 33)
      
      FixedExpenseList()
        .padding(.top, 16)
    }
  }
}

#Preview {
  FixedExpenseView()
}

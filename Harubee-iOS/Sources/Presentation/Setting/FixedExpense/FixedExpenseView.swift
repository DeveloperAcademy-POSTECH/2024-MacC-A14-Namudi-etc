//
//  FixedExpensesView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedExpenseView: View {
  var body: some View {
    VStack(spacing: 0) {
      HeaderView()
      BodyView()
        .ignoresSafeArea()
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("총 0건")
      Text("총 0원")
    }
    .font(.system(size: 24, weight: .semibold))
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 26)
    .padding(.top, 36)
    
    Rectangle()
      .frame(height: 1)
      .padding(.horizontal, 18)
      .padding(.top, 12)
      .foregroundStyle(.gray)
  }
}

private struct BodyView: View {
  var body: some View {
    VStack(spacing: 0) {
      Button(action: {}, label: {
        Image(systemName: "plus")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26, height: 29)
          .foregroundStyle(.black)
      })
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.horizontal, 16)
      
      FixedExpenseList()
        .padding(.top, 16)
    }
    .padding(.top, 14)
  }
}

#Preview {
  FixedExpenseView()
}

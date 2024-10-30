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
      .font(.system(size: 24, weight: .semibold))
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 26)
      .padding(.top, 44)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(.gray)
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
          .font(.system(size: 16, weight: .semibold))
        
        Spacer()
        
        Button(action: {}, label: {
          Image(systemName: "plus")
            .frame(width: 19, height: 21)
        })
      }
      .foregroundStyle(.black)
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

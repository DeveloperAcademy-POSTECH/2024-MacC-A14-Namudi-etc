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
    ZStack {
      Color.blue
        .ignoresSafeArea()
      VStack {
        HeaderView()
        BodyView()
          .ignoresSafeArea()
      }
    }
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("매월 나가는 지출 내역을")
      Text("추가해 주세요")
    }
    .font(.system(size: 24, weight: .bold))
    .foregroundStyle(Color.white)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 26)
    .padding(.top, 32)
  }
}

private struct BodyView: View {
  var body: some View {
    ZStack(alignment: .leading) {
      Rectangle()
        .fill(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      
      VStack {
        Text("고정지출 내역")
          .padding(.top, 38)
          .padding(.horizontal, 24)
          .font(.system(size: 20, weight: .semibold))
          .frame(maxWidth: .infinity, alignment: .leading)
        FixedExpenseInputCell(fixedExpenseName: "", fixedExpenseAmount: "")
        
      }
    }
    .padding(.top, 27)
  }
}

#Preview {
  FixedExpenseView()
}

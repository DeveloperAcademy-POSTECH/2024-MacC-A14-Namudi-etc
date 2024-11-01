//
//  FixedIncomeModifyView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedIncomeModifyView: View {
  @State private var fixedIncomeAmount: String = ""
  
  var body: some View {
    VStack(spacing: 0) {
      Text("금액")
        .font(.pretendardMedium_18)
        .foregroundStyle(Color.textBlack)
        .padding(.top, 20)
      
      FloatingTitleTextField(title: "금액", text: $fixedIncomeAmount)
        .padding(.top, 38)
      
      Button {
        print(fixedIncomeAmount)
      } label: {
        Text("저장하기")
          .font(.pretendardMedium_18)
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .foregroundStyle(Color.whiteDefault)
          .background(Color.main)
      }
      .padding(.top, 24)
      
      NumberKeypadView(text: $fixedIncomeAmount)
        .padding(.top, 26)
        .padding(.horizontal, 16)
        .padding(.bottom, 31)
    }
    .ignoresSafeArea()
  }
}

#Preview {
  FixedIncomeModifyView()
}

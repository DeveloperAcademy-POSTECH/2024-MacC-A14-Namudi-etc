//
//  FixedIncomeModifyView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

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
        .padding(.horizontal, 16)
      
      MainColorButton(
        title: "저장하기",
        isEnabled: .constant(true)
      ) {
        print("저장하기 버튼 Tapped")
      }
      .padding(.top, 24)
      
      NumberKeypadView(text: $fixedIncomeAmount) {
        print("Done")
      }
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

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
  @Environment(\.dismiss) private var dismiss
  @State private var fixedIncomeAmount: String
  
  private var action: (String) -> Void
  
  init(
    fixedIncomeAmount: String,
    action: @escaping (String) -> Void
  ) {
    self.fixedIncomeAmount = fixedIncomeAmount
    self.action = action
  }
  
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
        title: "완료하기",
        isEnabled: .constant(true)
      ) {
        action(fixedIncomeAmount)
        dismiss()
      }
      .padding(.top, 24)
      
      NumberKeypadView(expression: $fixedIncomeAmount) { isEnabled in
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
  FixedIncomeModifyView(fixedIncomeAmount: "") {_ in 
    print("button tapped")
  }
}

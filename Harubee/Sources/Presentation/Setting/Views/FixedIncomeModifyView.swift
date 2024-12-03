//
//  FixedIncomeModifyView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedIncomeModifyView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var isFocused: Bool = false
  @State private var fixedIncomeAmount: String
  
  private let editFixedIncomeAmount: (String) -> Void
  
  private var isErrorTextVisible: Bool {
    fixedIncomeAmount.isEmpty || (fixedIncomeAmount.numberFormat ?? 0 <= 0)
  }
  
  init(
    fixedIncomeAmount: String,
    editFixedIncomeAmount: @escaping (String) -> Void
  ) {
    self._fixedIncomeAmount = State(initialValue: fixedIncomeAmount)
    self.editFixedIncomeAmount = editFixedIncomeAmount
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        FloatingTitleNumberField(
          title: "금액",
          textSize: .medium,
          text: $fixedIncomeAmount,
          isFocused: $isFocused,
          isErrorTextVisible: isErrorTextVisible
        )
        .padding(.top, 38)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .onTapGesture {
          isFocused = true
        }
        
        Spacer()
        
        MainColorBottomButton(
          title: "완료하기",
          isEnabled: .constant(!isErrorTextVisible)
        ) {
          editFixedIncomeAmount(fixedIncomeAmount)
          dismiss()
        }
      }
      
      if isFocused {
        NumberKeypadView(amount: $fixedIncomeAmount) {
          isFocused = false
        }
      }
    }
    .navigationBarStyle(.sheet(title: "고정수입 금액 입력"))
  }
}

#Preview {
  FixedIncomeModifyView(fixedIncomeAmount: "") {_ in
    print("button tapped")
  }
}

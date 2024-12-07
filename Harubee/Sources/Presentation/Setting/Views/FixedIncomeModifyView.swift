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
  @State private var isEnabled: Bool = false
  @State private var fixedIncomeAmount: String = ""
  
  let beforeFixedIncomeAmount: String
  let editFixedIncomeAmount: (String) -> Void
  
  init(
    fixedIncomeAmount: String,
    editFixedIncomeAmount: @escaping (String) -> Void
  ) {
    self.beforeFixedIncomeAmount = fixedIncomeAmount
    self.editFixedIncomeAmount = editFixedIncomeAmount
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        FloatingTitleNumberField(
          title: "금액",
          textSize: .medium,
          text: $fixedIncomeAmount,
          isFocused: $isFocused
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
          isEnabled: $isEnabled
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
    .onAppear {
      self.fixedIncomeAmount = beforeFixedIncomeAmount
    }
    .onChange(of: fixedIncomeAmount) { oldValue, newValue in
      // 변경한 금액이 이전 금액과 같지 않고, 금액이 0보다 큰 경우 활성화
      if newValue != beforeFixedIncomeAmount
          && newValue.numberFormat ?? 0 > 0 {
        isEnabled = true
      } else {
        isEnabled = false
      }
    }
  }
}

#Preview {
  FixedIncomeModifyView(fixedIncomeAmount: "") {_ in
    print("button tapped")
  }
}

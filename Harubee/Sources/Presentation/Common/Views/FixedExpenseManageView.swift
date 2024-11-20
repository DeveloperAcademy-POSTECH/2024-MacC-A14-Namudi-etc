//
//  FixedExpenseAddView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

enum Mode {
  case add
  case modify
  
  var title: String {
    switch self {
    case .add:
      return "추가"
    case .modify:
      return "수정"
    }
  }
}

struct FixedExpenseManageView: View {
  let mode: Mode
  let action: ((Int, String, String) -> Void)
  
  @Environment(\.dismiss) private var dismiss
  @State private var selectedDay: Int = 1
  @State private var fixedExpenseName: String = ""
  @State private var fixedExpenseAmount: String = ""
  @State private var isEnabled: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      BottomSheetHeaderView(title: "고정지출 내역 \(mode.title)")
      
      BodyView(
        fixedExpenseName: $fixedExpenseName,
        fixedExpenseAmount: $fixedExpenseAmount,
        selectedDay: $selectedDay
      )
        .padding(.top, 37)
      
      Spacer()
      
      MainColorBottomButton(
        title: "저장하기",
        isEnabled: $isEnabled
      ) {
        self.action(selectedDay, fixedExpenseName, fixedExpenseAmount)
        self.dismiss()
      }
    }
    .onChange(of: selectedDay) { oldValue, newValue in
      if oldValue != newValue {
        isEnabled = true
      } else {
        isEnabled = false
      }
    }
    .onChange(of: fixedExpenseName) { _, _ in
      if (fixedExpenseName.isEmpty
          || fixedExpenseAmount.isEmpty
          || fixedExpenseAmount == "0") {
        isEnabled = false
      } else {
        isEnabled = true
      }
    }
    .onChange(of: fixedExpenseAmount) { _, _ in
      if (fixedExpenseName.isEmpty
          || fixedExpenseAmount.isEmpty
          || fixedExpenseAmount == "0") {
        isEnabled = false
      } else {
        isEnabled = true
      }
    }
  }
}

private struct BodyView: View {
  @Binding var fixedExpenseName: String
  @Binding var fixedExpenseAmount: String
  @Binding var selectedDay: Int
  
  var body: some View {
    VStack(spacing: 0) {
      DayPickerView(
        title: "날짜",
        titleFont: .view,
        selectedDay: $selectedDay
      )
      
      FloatingTitleTextField(
        title: "이름",
        text: $fixedExpenseName
      )
        .padding(.horizontal, 16)
        .padding(.top, 20)
      
      FloatingTitleTextField(
        title: "금액",
        text: $fixedExpenseAmount
      )
        .padding(.horizontal, 16)
        .padding(.top, 22)
        .keyboardType(.numberPad)
    }
    .onChange(of: fixedExpenseAmount) { _, _ in
      fixedExpenseAmount = (fixedExpenseAmount.numberFormat ?? 0).decimal
    }
  }
}

#Preview {
  FixedExpenseManageView(mode: .add) { _, _, _ in
  }
}

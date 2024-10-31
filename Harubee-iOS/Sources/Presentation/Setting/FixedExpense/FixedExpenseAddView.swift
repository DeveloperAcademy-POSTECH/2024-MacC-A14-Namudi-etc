//
//  FixedExpenseAddView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

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

struct FixedExpenseAddView: View {
  
  private let mode: Mode
  @State private var fixedExpenseName: String
  @State private var fixedExpenseAmount: String
  @State private var selectedDay: Int
  
  init(
    mode: Mode,
    fixedExpenseName: String = "",
    fixedExpenseAmount: String = "",
    selectedDay: Int = 1
  ) {
    self.mode = mode
    self._fixedExpenseName = State(initialValue: fixedExpenseName)
    self._fixedExpenseAmount = State(initialValue: fixedExpenseAmount)
    self._selectedDay = State(initialValue: selectedDay)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text("고정지출 내역 \(mode.title)")
        .font(.pretendardMedium_18)
        .padding(.top, 20)
      
      BodyView(fixedExpenseName: $fixedExpenseName, fixedExpenseAmount: $fixedExpenseAmount, selectedDay: $selectedDay)
        .padding(.top, 37)
      
      Spacer()
      
      Button {
        print(fixedExpenseName)
        print(fixedExpenseAmount)
        print(selectedDay)
      } label: {
        Text("저장하기")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.whiteDeep)
          .padding(.horizontal, 149)
          .padding(.vertical, 20)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.main)
            // textfield 다 안 채워지면 Main_30
          )
      }
      .padding(.bottom, 9)
    }
  }
}

private struct BodyView: View {
  
  @Binding var fixedExpenseName: String
  @Binding var fixedExpenseAmount: String
  @Binding var selectedDay: Int
  
  var body: some View {
    VStack(spacing: 20) {
      DayPickerView(title: "날짜", selectedDay: $selectedDay)
      
      FloatingTitleTextField(title: "이름", text: $fixedExpenseName, shouldShowKeyboard: false)
      FloatingTitleTextField(title: "금액", text: $fixedExpenseAmount, shouldShowKeyboard: false)
    }
  }
}

#Preview {
  FixedExpenseAddView(mode: .add)
}

//
//  FixedExpenseAddView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

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
      
      MainColorButton(
        title: "저장하기",
        // TODO: Binding 연결 필요
        isEnabled: .constant(true)
      ) {
        print("저장하기 버튼 Tapped")
      }
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .padding(.horizontal, 16)
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
      DayPickerView(title: "날짜", titleFont: .view, selectedDay: $selectedDay)
      
      FloatingTitleTextField(title: "이름", text: $fixedExpenseName)
        .padding(.horizontal, 16)
      FloatingTitleTextField(title: "금액", text: $fixedExpenseAmount)
        .padding(.horizontal, 16)
    }
  }
}

#Preview {
  FixedExpenseAddView(mode: .add)
}

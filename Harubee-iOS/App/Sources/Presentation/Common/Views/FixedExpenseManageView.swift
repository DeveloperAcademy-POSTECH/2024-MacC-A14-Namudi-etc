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

struct FixedExpenseManageView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var selectedDay: Int
  @State private var fixedExpenseName: String
  @State private var fixedExpenseAmount: String
  
  @State private var isEnabled: Bool = false
  
  @State private var keyboardObserver = KeyboardObserver()

  private let mode: Mode
  private let action: ((Int, String, String) -> Void)
  
  init(
    mode: Mode,
    selectedDay: Int = 1,
    fixedExpenseName: String = "",
    fixedExpenseAmount: String = "",
    action: @escaping ((Int, String, String) -> Void)
  ) {
    self.mode = mode
    self._fixedExpenseName = State(initialValue: fixedExpenseName)
    self._fixedExpenseAmount = State(initialValue: fixedExpenseAmount)
    self._selectedDay = State(initialValue: selectedDay)
    self.action = action
  }
  
  var body: some View {
    VStack(spacing: 0) {
      BottomSheetHeaderView(title: "고정지출 내역 \(mode.title)")
      
      BodyView(
        fixedExpenseName: $fixedExpenseName,
        fixedExpenseAmount: $fixedExpenseAmount,
        selectedDay: $selectedDay,
        isKeyboardVisible: $keyboardObserver.isKeyboardVisible
      )
        .padding(.top, 37)
      
      Spacer()
      
      MainColorButton(
        title: "저장하기",
        isEnabled: $isEnabled,
        cornerRadius: 10
      ) {
        self.action(selectedDay, fixedExpenseName, fixedExpenseAmount)
        self.dismiss()
      }
      .padding(.horizontal, 16)
      .padding(.bottom, 9)
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
  
  @Binding private var fixedExpenseName: String
  @Binding private var fixedExpenseAmount: String
  @Binding private var selectedDay: Int
  @Binding private var isKeyboardVisible: Bool
  
  init(
    fixedExpenseName: Binding<String>,
    fixedExpenseAmount: Binding<String>,
    selectedDay: Binding<Int>,
    isKeyboardVisible: Binding<Bool>
  ) {
    self._fixedExpenseName = fixedExpenseName
    self._fixedExpenseAmount = fixedExpenseAmount
    self._selectedDay = selectedDay
    self._isKeyboardVisible = isKeyboardVisible
  }
  
  var body: some View {
    VStack(spacing: 20) {
      DayPickerView(
        title: "날짜",
        titleFont: .view,
        selectedDay: $selectedDay,
        isKeyboardVisible: $isKeyboardVisible
      )
      
      FloatingTitleTextField(
        title: "이름",
        text: $fixedExpenseName
      )
        .padding(.horizontal, 16)
      
      FloatingTitleTextField(
        title: "금액",
        text: $fixedExpenseAmount
      )
        .padding(.horizontal, 16)
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

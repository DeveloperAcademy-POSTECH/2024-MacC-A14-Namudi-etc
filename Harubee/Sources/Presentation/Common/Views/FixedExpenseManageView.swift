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
  @State private var selectedDay: Int
  @State private var fixedExpenseName: String
  @State private var fixedExpenseAmount: String
  @State private var isEnabled: Bool = false
  @State private var isNumberFieldFocused: Bool = false
  
  // TODO: 버튼 활성화 로직 구현 필요
  private let beforeSelectedDay: Int
  private let beforeExpenseName: String
  private let beforeExpenseAmount: String
  
  init(
    mode: Mode,
    selectedDay: Int = 1,
    fixedExpenseName: String = "",
    fixedExpenseAmount: String = "",
    action: @escaping (Int, String, String) -> Void
  ) {
    self.mode = mode
    self.action = action
    self._selectedDay = State(initialValue: selectedDay)
    self._fixedExpenseName = State(initialValue: fixedExpenseName)
    self._fixedExpenseAmount = State(initialValue: fixedExpenseAmount)
    self.beforeSelectedDay = selectedDay
    self.beforeExpenseName = fixedExpenseName
    self.beforeExpenseAmount = fixedExpenseAmount
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        BodyView(
          fixedExpenseName: $fixedExpenseName,
          fixedExpenseAmount: $fixedExpenseAmount,
          selectedDay: $selectedDay,
          isNumberFieldFocused: $isNumberFieldFocused
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
      .ignoresSafeArea(.keyboard)
      
      if isNumberFieldFocused {
        NumberKeypadView(amount: $fixedExpenseAmount) {
          self.isNumberFieldFocused = false
        }
      }
    }
    .navigationBarStyle(.sheet(title: "고정지출 내역"))
    .onChange(of: selectedDay) { _, newValue in
      if mode == .modify {
        if beforeSelectedDay == newValue {
          isEnabled = false
        } else {
          updateIsEnabled()
        }
      } else {
        updateIsEnabled()
      }
    }
    .onChange(of: fixedExpenseName) { _, _ in
      updateIsEnabled()
    }
    .onChange(of: fixedExpenseAmount) { _, _ in
      updateIsEnabled()
    }
  }
  
  private func updateIsEnabled() {
    if !fixedExpenseName.isEmpty
        && !fixedExpenseAmount.isEmpty
        && fixedExpenseAmount != "0" {
      isEnabled = true
    } else {
      isEnabled = false
    }
  }
}

private struct BodyView: View {
  @State private var keyboardObserver = KeyboardObserverManager()
  @Binding var fixedExpenseName: String
  @Binding var fixedExpenseAmount: String
  @Binding var selectedDay: Int
  @Binding var isNumberFieldFocused: Bool
  
  @State private var showDayPicker: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      DayPickerView(
        title: "날짜",
        titleFont: .view,
        showDayPicker: $showDayPicker,
        selectedDay: $selectedDay
      )
      
      FloatingTitleTextField(
        title: "이름",
        text: $fixedExpenseName
      )
      .padding(.horizontal, 16)
      .padding(.top, 20)
      
      FloatingTitleNumberField(
        title: "금액",
        textSize: .medium,
        text: $fixedExpenseAmount,
        isFocused: $isNumberFieldFocused,
        minimum: .overZero
      )
      .padding(.horizontal, 16)
      .padding(.top, 22)
      .onTapGesture {
        showDayPicker = false
        keyboardObserver.hideKeyboard()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          isNumberFieldFocused = true
        }
      }
    }
    .onChange(of: keyboardObserver.isKeyboardVisible) {
      if $1 {
        self.showDayPicker = false
        self.isNumberFieldFocused = false
      }
    }
    .onChange(of: showDayPicker) {
      if $1 {
        self.isNumberFieldFocused = false
        keyboardObserver.hideKeyboard()
      }
    }
  }
}

#Preview {
  FixedExpenseManageView(mode: .add) { _, _, _ in
  }
}

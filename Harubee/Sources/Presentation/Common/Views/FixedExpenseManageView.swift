//
//  FixedExpenseAddView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

private enum Mode {
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
  @Environment(RootViewSwitcher.self) private var rootViewSwitcher
  @Environment(OnboardingCoordinator.self) private var onboardingCoordinator
  @Environment(MainCoordinator.self) private var mainCoordinator
  @State private var selectedDay: Int
  @State private var fixedExpenseName: String
  @State private var fixedExpenseAmount: String
  @State private var isEnabled: Bool = false
  @State private var isNumberFieldFocused: Bool = false
  
  private let mode: Mode
  private let beforeSelectedDay: Int
  private let beforeExpenseName: String
  private let beforeExpenseAmount: String
  
  init(
    selectedDay: Int = 1,
    fixedExpenseName: String = "",
    fixedExpenseAmount: String = ""
  ) {
    self.mode = fixedExpenseName.isEmpty && fixedExpenseAmount.isEmpty ? .add : .modify
    self.beforeSelectedDay = selectedDay
    self.beforeExpenseName = fixedExpenseName
    self.beforeExpenseAmount = fixedExpenseAmount
    
    self._selectedDay = State(initialValue: selectedDay)
    self._fixedExpenseName = State(initialValue: fixedExpenseName)
    self._fixedExpenseAmount = State(initialValue: fixedExpenseAmount)
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
          self.dismissSheet()
        }
      }
      .ignoresSafeArea(.keyboard)
      
      if isNumberFieldFocused {
        NumberKeypadView(amount: $fixedExpenseAmount) {
          self.isNumberFieldFocused = false
        }
      }
    }
    .navigationBarStyle(.sheet(title: "고정지출 내역 \(mode.title)"))
    .onChange(of: selectedDay) { _, _ in
      updateIsEnabled()
    }
    .onChange(of: fixedExpenseName) { _, _ in
      updateIsEnabled()
    }
    .onChange(of: fixedExpenseAmount) { _, _ in
      updateIsEnabled()
    }
  }
  
  private func updateIsEnabled() {
    
    let isUpdatedDay = (
      mode != .modify
      || beforeSelectedDay != selectedDay
    )
    let isUpdatedName = fixedExpenseName != beforeExpenseName
    let isUpdatedAmount = fixedExpenseAmount != beforeExpenseAmount

    let isValidAmount = (
      !fixedExpenseAmount.isEmpty
      && (fixedExpenseAmount.numberFormat ?? 0) > 0
    )
    let isValidName = !fixedExpenseName.isEmpty

    if isValidName && isValidAmount {
        if mode == .add {
            isEnabled = true
        } else {
            isEnabled = (
              isUpdatedDay
              || isUpdatedName
              || isUpdatedAmount
            )
        }
    } else {
        isEnabled = false
    }
  }
  
  private func dismissSheet() {
    switch rootViewSwitcher.root {
    case .onboarding:
      onboardingCoordinator.dismissFixedExpenseManageSheet(
        day: selectedDay,
        name: fixedExpenseName,
        amount: fixedExpenseAmount
      )
    case .main:
      mainCoordinator.dismissFixedExpenseManageSheet(
        day: selectedDay,
        name: fixedExpenseName,
        amount: fixedExpenseAmount
      )
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
      .padding(.horizontal, 20)
      
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
  FixedExpenseManageView()
    .environment(MainCoordinator())
    .environment(OnboardingCoordinator())
    .environment(RootViewSwitcher())
}

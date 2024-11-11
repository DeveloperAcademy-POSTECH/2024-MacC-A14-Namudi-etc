//
//  FixedIncomeView.swift
//  Data
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared
import Domain

struct FixedIncomeView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var isUpdated: Bool = false
  @State private var isDayUpdated: Bool = false
  @State private var selectedDay: Int
  @State private var fixedIncomeAmount: Int
  @State private var isInfoBubbleVisible: Bool = false
  @State private var isAlertPresented: Bool = false
  
  @StateObject private var keyboardObserver = KeyboardObserver()
  
  private var settingViewModel: SettingViewModel
  
  init(
    settingViewModel: SettingViewModel
  ) {
    self.settingViewModel = settingViewModel
    self.selectedDay = settingViewModel.state.salaryBudget?.startDate.day ?? 1
    self.fixedIncomeAmount = settingViewModel.state.salaryBudget?.fixedIncome ?? 0
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 48) {
        HeaderView(isInfoBubbleVisible: $isInfoBubbleVisible)
        .zIndex(1)
        
        BodyView(
          settingViewModel: settingViewModel,
          selectedDay: $selectedDay,
          fixedIncomeAmount: $fixedIncomeAmount,
          isKeyboardVisible: $keyboardObserver.isKeyboardVisible
        )
        
        Spacer()
        
        MainColorButton(
          title: "저장하기",
          isEnabled: $isUpdated,
          cornerRadius: 10
        ) {
          if isDayUpdated {
            isAlertPresented = true
          } else {
            settingViewModel.send(.fixedIncomeSaveButtonTapped(selectedDay, fixedIncomeAmount))
            dismiss()
          }
        }
        .padding(.bottom, 9)
        .padding(.horizontal, 16)
      }
      .onChange(of: selectedDay) { _, newValue in
        if newValue != settingViewModel.state.salaryBudget?.startDate.day {
          isDayUpdated = true
          isUpdated = true
        } else {
          isUpdated = false
        }
      }
      .onChange(of: fixedIncomeAmount) { _, newValue in
        if newValue != settingViewModel.state.salaryBudget?.fixedIncome {
          isUpdated = true
        } else {
          isUpdated = false
        }
      }
      .frame(maxHeight: .infinity, alignment: .top)
      .navigationBarStyle(.white(title: "고정수입 관리", backTitle: "뒤로"))
      
      if isInfoBubbleVisible {
        Color.clear
          .contentShape(Rectangle())
          .ignoresSafeArea()
          .onTapGesture {
            
            isInfoBubbleVisible.toggle()
          }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          isInfoBubbleVisible.toggle()
        } label: {
          Image(systemName: "questionmark.circle")
            .font(Font.system(size: 18, weight: .regular))
            .foregroundStyle(Color.textBlack)
        }
      }
    }
    .alert(isPresented: $isAlertPresented) {
      Alert(
        title: Text("수입일을 \(selectedDay)일로 바꾸시겠어요?"),
        message: Text("수입일을 바꾸면 모든 데이터가 초기화되며,\n\(selectedDay)일 기준으로 하루비가 다시 계산돼요"),
        primaryButton: .default(Text("취소")),
        secondaryButton: .destructive(Text("확인")) {
          settingViewModel.send(.fixedIncomeSaveButtonTapped(selectedDay, fixedIncomeAmount))
          dismiss()
        }
      )
    }
  }
}

private struct HeaderView: View {
  @Binding private var isInfoBubbleVisible: Bool
  
  init(isInfoBubbleVisible: Binding<Bool>) {
    self._isInfoBubbleVisible = isInfoBubbleVisible
  }
  
  var body: some View {
    VStack(spacing: 4) {
      VStack(alignment: .leading, spacing: 10) {
        Text("고정수입 날짜를 기준으로")
        Text("하루비를 알려드릴게요.")
      }
      .foregroundStyle(Color.textBlack)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 4)
      .infoBubble(isVisible: $isInfoBubbleVisible, alignment: .bottomLeading) {
        VStack(alignment: .leading, spacing: 2) {
          Text("하루비는 고정수입 날짜와 금액을 기준으로 계산돼요")
          Text("원활한 서비스 사용을 위해, 정확한 정보를 입력해주세요")
        }
        .font(.pretendardSemibold_12)
        .foregroundStyle(Color.textBlack)
      }
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
    }
    .font(.pretendardSemibold_22)
    .padding(.horizontal, 16)
    .padding(.top, 44)
  }
}

private struct BodyView: View {
  @State private var showingSheet: Bool = false
  @Binding private var selectedDay: Int
  @Binding private var fixedIncomeAmount: Int
  @Binding private var isKeyboardVisible: Bool
  
  private var settingViewModel: SettingViewModel
  
  init(
    settingViewModel: SettingViewModel,
    selectedDay: Binding<Int>,
    fixedIncomeAmount: Binding<Int>,
    isKeyboardVisible: Binding<Bool>
  ) {
    self.settingViewModel = settingViewModel
    self._selectedDay = selectedDay
    self._fixedIncomeAmount = fixedIncomeAmount
    self._isKeyboardVisible = isKeyboardVisible
  }
  
  var body: some View {
    VStack(spacing: 30) {
      DayPickerView(
        title: "주요 고정수입 날짜",
        titleFont: .view,
        selectedDay: $selectedDay,
        isKeyboardVisible: $isKeyboardVisible
      )
      
      HStack(spacing: 0) {
        Text("금액")
          .font(.pretendardMedium_18)
        
        Spacer()
        
        Button {
          showingSheet.toggle()
        } label: {
          HStack(spacing: 2) {
            Text(fixedIncomeAmount.decimalWithWon)
              .font(.pretendardMedium_20)
            Image(systemName: "pencil")
              .frame(width: 21, height: 24)
          }
          .foregroundStyle(Color.textBlack)
        }
        .sheet(isPresented: $showingSheet) {
          FixedIncomeModifyView(
            fixedIncomeAmount: settingViewModel.state.salaryBudget?.fixedIncome.decimal ?? ""
          ) { fixedIncomeString in
            fixedIncomeAmount = fixedIncomeString.numberFormat ?? 0
          }
          .presentationDetents([.fraction(0.6)])
          .presentationCornerRadius(20)
        }
      }
      .padding(.horizontal, 20)
    }
  }
}

//#Preview {
//  FixedIncomeView(settingViewModel: SettingViewModel(
//    salaryBudget: SalaryBudget(
//      startDate: Date(),
//      endDate: Date(),
//      fixedIncome: 1_000_000,
//      fixedExpenses: [],
//      balance: 0,
//      defaultHarubee: 0,
//      dailyBudgets: []
//    ),
//    budgetUseCase: BUd
//  ))
//}

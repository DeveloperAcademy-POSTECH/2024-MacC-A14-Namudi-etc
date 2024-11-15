//
//  FixedIncomeView.swift
//  Data
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedIncomeView: View {
  private var settingViewModel: SettingViewModel
  private var salaryBudget: SalaryBudget {
    settingViewModel.state.salaryBudget
  }
  private var fixedIncomeHeaderView: some View {
    VStack(spacing: 4) {
      VStack(alignment: .leading, spacing: 10) {
        Text("고정수입 날짜를 기준으로")
        Text("하루비를 알려드릴게요.")
      }
      .foregroundStyle(Color.textBlack)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 4)
      .infoBubble($isInfoBubbleVisible)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
    }
    .font(.pretendardSemibold_22)
    .padding(.horizontal, 16)
    .padding(.top, 44)
  }
  
  @Environment(\.dismiss) private var dismiss
  @State private var selectedDay: Int
  @State private var fixedIncomeAmount: Int
  
  @State private var isUpdated: Bool = false
  @State private var isInfoBubbleVisible: Bool = false
  @State private var isAlertPresented: Bool = false
  
  init(
    settingViewModel: SettingViewModel
  ) {
    self.settingViewModel = settingViewModel
    self.selectedDay = settingViewModel.state.salaryBudget.startDate.day
    self.fixedIncomeAmount = settingViewModel.state.salaryBudget.fixedIncome
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 48) {
        fixedIncomeHeaderView
        .zIndex(1)
        
        FixedIncomeBodyView(
          settingViewModel: settingViewModel,
          selectedDay: $selectedDay,
          fixedIncomeAmount: $fixedIncomeAmount
        )
        
        Spacer()
        
        MainColorBottomButton(
          title: "저장하기",
          isEnabled: $isUpdated
        ) {
          if selectedDay != salaryBudget.startDate.day {
            isAlertPresented = true
          } else {
            settingViewModel.send(.fixedIncomeSaveButtonTapped(
              selectedDay,
              fixedIncomeAmount
            ))
            dismiss()
          }
        }
      }
      .onChange(of: selectedDay) { _, _ in
        isUpdated = (
          selectedDay != salaryBudget.startDate.day
          || fixedIncomeAmount != salaryBudget.fixedIncome
        )

      }
      .onChange(of: fixedIncomeAmount) { _, _ in
        isUpdated = (
          selectedDay != salaryBudget.startDate.day
          || fixedIncomeAmount != salaryBudget.fixedIncome
        )

      }
      .frame(maxHeight: .infinity, alignment: .top)
      
      if isInfoBubbleVisible {
        Color.clear
          .contentShape(Rectangle())
          .ignoresSafeArea()
          .onTapGesture { isInfoBubbleVisible.toggle() }
      }
    }
    .applyNavigationBarStyle(isInfoBubbleVisible: $isInfoBubbleVisible)
    .alert(isPresented: $isAlertPresented) {
      Alert(
        title: Text("수입일을 \(selectedDay)일로 바꾸시겠어요?"),
        message: Text("""
        수입일을 바꾸면 모든 데이터가 초기화되며,
        \(selectedDay)일 기준으로 하루비가 다시 계산돼요
        """),
        primaryButton: .default(Text("취소")),
        secondaryButton: .destructive(Text("확인")) {
          settingViewModel.send(.fixedIncomeSaveButtonTapped(
            selectedDay,
            fixedIncomeAmount
          ))
          dismiss()
        }
      )
    }
  }
}

private struct FixedIncomeBodyView: View {
  let settingViewModel: SettingViewModel
  
  @State private var showingSheet: Bool = false
  @Binding var selectedDay: Int
  @Binding var fixedIncomeAmount: Int
  
  var body: some View {
    VStack(spacing: 30) {
      DayPickerView(
        title: "주요 고정수입 날짜",
        titleFont: .view,
        selectedDay: $selectedDay
      )
      
      HStack(spacing: 0) {
        Text("금액")
          .font(.pretendardMedium_18)
        
        Spacer()
        
        Button {
          showingSheet.toggle()
        } label: {
          HStack(spacing: 3) {
            Text(fixedIncomeAmount.decimalWithWon)
              .font(.pretendardMedium_20)
              .foregroundStyle(Color.textBlack)
            Image(systemName: "pencil")
              .frame(width: 21, height: 24)
              .foregroundStyle(Color.textBlack30)
          }
        }
        .sheet(isPresented: $showingSheet) {
          FixedIncomeModifyView(
            fixedIncomeAmount: settingViewModel.state.salaryBudget.fixedIncome.decimalWithWon
          ) { fixedIncomeString in
            fixedIncomeAmount = fixedIncomeString.numberFormat ?? 0
          }
          .presentationDetents([.height(497)])
          .presentationCornerRadius(20)
        }
      }
      .padding(.horizontal, 20)
    }
  }
}

// MARK: - View Modifiers
private extension View {
  func applyNavigationBarStyle(
    isInfoBubbleVisible: Binding<Bool>
  ) -> some View {
    self
      .navigationBarStyle(.white(title: "고정수입 관리", backTitle: "뒤로"))
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          HelpButton(
            infoBubbleVisible: isInfoBubbleVisible,
            buttonColor: .textBlack
          )
        }
      }
  }
}

// MARK: - InfoBubbles Modifiers
private extension View {
  func infoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .infoBubble(isVisible: isVisible, alignment: .bottomLeading) {
        VStack(alignment: .leading, spacing: 2) {
          Text("하루비는 고정수입 날짜와 금액을 기준으로 계산돼요")
          Text("원활한 서비스 사용을 위해, 정확한 정보를 입력해주세요")
        }
        .font(.pretendardSemibold_12)
        .foregroundStyle(Color.textBlack)
      }
  }
}


#Preview {
  FixedIncomeView(
    settingViewModel: DIContainer.shared.makeSettingViewModel(
      salaryBudget: SalaryBudget.default
    )
  )
}

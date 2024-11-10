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
  @State private var selectedDay: Int
  @State private var fixedIncomeAmount: Int
  
  private var settingViewModel: SettingViewModel
  
  init(
    settingViewModel: SettingViewModel
  ) {
    self.settingViewModel = settingViewModel
    self.selectedDay = settingViewModel.state.salaryBudget?.startDate.day ?? 1
    self.fixedIncomeAmount = settingViewModel.state.salaryBudget?.fixedIncome ?? 0
  }
  
  var body: some View {
    VStack(spacing: 48) {
      HeaderView()
      
      BodyView(
        settingViewModel: settingViewModel,
        selectedDay: $selectedDay,
        fixedIncomeAmount: $fixedIncomeAmount
      )
      
      Spacer()
      
      MainColorButton(
        title: "저장하기",
        isEnabled: $isUpdated
      ) {
        settingViewModel.send(.fixedIncomeSaveButtonTapped(selectedDay, fixedIncomeAmount))
        dismiss()
      }
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .padding(.bottom, 9)
      .padding(.horizontal, 16)
    }
    .onChange(of: selectedDay) { _, newValue in
      if newValue != settingViewModel.state.salaryBudget?.startDate.day {
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
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(spacing: 4) {
      VStack(alignment: .leading, spacing: 10) {
        Text("고정수입 날짜를 기준으로")
        Text("하루비를 알려드릴게요.")
      }
      .foregroundStyle(Color.textBlack)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 4)
      
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
  
  private var settingViewModel: SettingViewModel
  
  init(
    settingViewModel: SettingViewModel,
    selectedDay: Binding<Int>,
    fixedIncomeAmount: Binding<Int>
  ) {
    self.settingViewModel = settingViewModel
    self._selectedDay = selectedDay
    self._fixedIncomeAmount = fixedIncomeAmount
  }
  
  var body: some View {
    VStack(spacing: 30) {
      DayPickerView(title: "주요 고정수입 날짜",
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

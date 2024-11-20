//
//  SettingView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct SettingView: View {
  let settingViewModel: SettingViewModel
  
  @State private var navigateFixedExpense: Bool = false
  @State private var navigateFixedIncome: Bool = false
  
  private var salaryBudget: SalaryBudget? {
    settingViewModel.state.salaryBudget
  }
  
  init(settingViewModel: SettingViewModel) {
    self.settingViewModel = settingViewModel
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 6) {
        
        SettingHeaderView(settingViewModel: settingViewModel)
        
        SectionContainer {
          SettingItem(
            title: "고정지출 관리",
            previewText: "총 \(salaryBudget?.fixedExpenses.count ?? 0)건 / \(salaryBudget?.fixedExpenses.reduce(0) { $0 + $1.price }.decimalWithWon ?? 0.decimalWithWon)"
          )
          .onTapGesture { navigateFixedExpense = true }
          .navigationDestination(
            isPresented: $navigateFixedExpense
          ) {
            FixedExpenseView(settingViewModel: settingViewModel)
          }
          
          SettingItem(
            title: "고정수입 관리",
            previewText: "매달 \(salaryBudget?.startDate.formattedDateToString(.day_kr) ?? "1일") / \(salaryBudget?.fixedIncome.decimalWithWon ?? "")"
          )
          .onTapGesture { navigateFixedIncome = true }
          .navigationDestination(
            isPresented: $navigateFixedIncome
          ) {
            FixedIncomeView(settingViewModel: settingViewModel)
          }
        }
        
        settingFooterView
      }.background(.textBlack5)
    }
    .ignoresSafeArea()
    .scrollIndicators(.hidden)
    .navigationBarStyle(.white(title: "설정", backTitle: "뒤로"))
    .font(.pretendardMedium_18)
    .foregroundStyle(Color.textBlack)
  }
  
  private var settingFooterView: some View {
    SectionContainer {
      VStack(alignment: .leading, spacing: 6) {
        Text("앱 버전")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
        
        Text("v\(Bundle.main.shortVersionString)")
          .font(.pretendardMedium_14)
          .foregroundStyle(Color.textBlack30)
      }.frame(maxWidth: .infinity, alignment: .leading)
      
      Text("현재 1.0.1")
        .font(.pretendardMedium_14)
        .foregroundStyle(Color.textBlack30)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 18)
    .padding(.vertical, 32)
    .background(Color.whiteDefault)
  }
}

// MARK: - SettingHeaderView
private struct SettingHeaderView: View {
  
  let settingViewModel: SettingViewModel
  
  @State private var harubeeNotificationSelectedTime: Date = .now
  @State private var expanseNotificationSelectedTime: Date = .now
  @State private var isHarubeeNotification: Bool = false
  @State private var isExpanseNotification: Bool = false
  
  var body: some View {
    VStack(spacing: 24) {
      PickerView(
        category: .setting,
        title: "오늘의 하루비 알림",
        isToggleOn: $isHarubeeNotification,
        selectedTime: $harubeeNotificationSelectedTime
      )
      
      PickerView(
        category: .setting,
        title: "실제 지출 입력 알림",
        isToggleOn: $isExpanseNotification,
        selectedTime: $expanseNotificationSelectedTime
      )
    }
    .padding(.top, 142)
    .padding(.bottom, 27)
    .background(Color.whiteDefault)
    .shadow(color: Color.textBlack5, radius: 3, x: 0, y: 1)
  }
}

// MARK: - SettingItem
private struct SettingItem: View {
  let title: String
  let previewText: String
  
  var body: some View {
    HStack(alignment: .center, spacing: 8) {
      Text(title)
        .font(.pretendardSemibold_18)
        .foregroundStyle(Color.textBlack)
      
      Spacer()
      
      Text(previewText)
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.main)
      
      Image(systemName: "chevron.right")
        .font(Font.system(size: 16, weight: .regular))
        .foregroundStyle(Color.textBlack)
        .frame(width: 12, height: 19)
    }
  }
}


// MARK: - SectionContainer
private struct SectionContainer<Content: View>: View {
  private let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 34) {
      content()
    }
    .padding(EdgeInsets(top: 32, leading: 18, bottom: 32, trailing: 18))
    .frame(maxWidth: .infinity)
    .background(Color.whiteDefault)
    .shadow(color: Color.textBlack5, radius: 3, x: 0, y: 1)
  }
}

#Preview {
  SettingView(
    settingViewModel: DIContainer.shared.makeSettingViewModel(
      salaryBudget: SalaryBudget.default
    )
  )
}

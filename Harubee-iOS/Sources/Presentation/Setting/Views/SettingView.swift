//
//  SettingView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct SettingView: View {
  @State private var navigateFixedExpense: Bool = false
  @State private var navigateFixedIncome: Bool = false
  @State private var settingViewModel: SettingViewModel
  
  private var salaryBudget: SalaryBudget? {
    settingViewModel.state.salaryBudget
  }
  
  private var settingFooterView: some View {
    SectionContainer {
      VStack(alignment: .leading, spacing: 6) {
        Text("앱 버전")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
        
        Text("현재 1.0.1")
          .font(.pretendardMedium_14)
          .foregroundStyle(Color.textBlack30)
      }.frame(maxWidth: .infinity, alignment: .leading)
      
//      SettingItem(title: "개발자 정보", previewText: "")
    }
  }
  
  init(settingViewModel: SettingViewModel) {
    self.settingViewModel = settingViewModel
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.textBlack5.edgesIgnoringSafeArea(.bottom)
      VStack(spacing: 6) {
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
      }
    }
    .navigationBarStyle(.white(title: "설정", backTitle: "뒤로"))
    .font(.pretendardMedium_18)
    .foregroundStyle(Color.textBlack)
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
    .padding(EdgeInsets(top: 32,
                        leading: 18,
                        bottom: 32,
                        trailing: 18))
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

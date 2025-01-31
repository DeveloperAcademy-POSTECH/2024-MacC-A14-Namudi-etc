//
//  SystemSmallWidgetView.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/22/24.
//

import SwiftUI
import WidgetKit

// MARK: - SystemSmallWidgetView
struct SystemSmallWidgetView: View {
  let entry: Provider.Entry
  
  var body: some View {
    VStack {
      if let salaryBudget = entry.salaryBudget {
        SystemSmallContentView(salaryBudget: salaryBudget)
      } else {
        WidgetAnnounceText()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

private struct SystemSmallContentView: View {
  
  let salaryBudget: SalaryBudget
  
  private var title: String {
    self.getTitle()
  }
  
  private var harubee: Int {
    self.getTodayHarubee()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      TodayHarubeeTextView(
        title: title,
        harubee: harubee,
        contentSize: .first
      )
      .padding(.horizontal, 19)
      
      Spacer()
      
      ExpenseInputButton(title: "실제 지출 입력하기")
        .padding(.horizontal, 16)
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 24)
    .padding(.bottom, 16)
    .background(.bgPrimary)
  }
  
  private func getTitle() -> String {
    let salaryBudget = salaryBudget
    let dailyBudget = salaryBudget.dailyBudgets.first(where: {
      $0.date == Date().formattedDate
    })
    
    return dailyBudget?.expense == nil
    ? "오늘의 하루비"
    : "오늘의 남은 하루비"
  }
  
  private func getTodayHarubee() -> Int {
    let salaryBudget = salaryBudget
    let dailyBudget = salaryBudget.dailyBudgets.first(where: {
      $0.date == Date().formattedDate
    })
    
    let harubee = dailyBudget?.harubee ?? (Int(salaryBudget.defaultHarubee))
    
    let expenseSum = dailyBudget?.expense ?? 0
    
    return harubee - expenseSum
  }
}

// MARK: - Preview
#Preview("SystemSmall", as: .systemSmall) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(
    date: .now,
    salaryBudget: nil
  )
}

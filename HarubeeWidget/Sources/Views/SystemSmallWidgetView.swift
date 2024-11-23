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
  
  private var todayHarubee: Int {
    self.getTodayHarubee()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("오늘의 하루비")
        .font(.pretendardMedium_14)
        .foregroundStyle(.textBright)
        .padding(.horizontal, 19)
      
      ViewThatFits {
        TodayHarubeeTextView(
          text: todayHarubee.decimalWithWon,
          contentSize: .first
        )
        
        TodayHarubeeTextView(
          text: todayHarubee.decimalWithWon,
          contentSize: .second
        )
      }
      .padding(.top, 2)
      .padding(.horizontal, 19)
      .lineLimit(1)
      
      
      Spacer()
      
      // TODO: AppIntent로 수정 필요
      ExpenseInputButton(title: "실제 지출 입력하기")
        .padding(.horizontal, 16)
      
    }
    .padding(.top, 24)
    .padding(.bottom, 16)
  }
  
  private func getTodayHarubee() -> Int {
    let salaryBudget = entry.salaryBudget
    let dailyBudget = entry.salaryBudget?.dailyBudgets.first(where: {
      $0.date == Date().formattedDate
    })
    
    let harubee = dailyBudget?.harubee ?? (Int(salaryBudget?.defaultHarubee ?? 0))
    
    let expenseSum = dailyBudget?.expense ?? 0
    
    return harubee - expenseSum
  }
}

// MARK: - Preview
#Preview("SystemSmall", as: .systemSmall) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(date: .now, salaryBudget: SalaryBudget.default)
}

//
//  SystemMediumWidgetView.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/22/24.
//

import SwiftUI
import WidgetKit

// MARK: - SystemMediumWidgetView
struct SystemMediumWidgetView: View {
  let entry: Provider.Entry
  
  var body: some View {
    VStack(spacing: 0) {
      BodyView(salaryBudget: entry.salaryBudget)
      
      Spacer()
      
      FooterView(salaryBudget: entry.salaryBudget)
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(.whiteDefault)
  }
}


// MARK: - BodyView
private struct BodyView: View {
  let salaryBudget: SalaryBudget?
  
  private var dailyStreak: [DailyStreak?] {
    WidgetManager.shared.getDailyStreak(salaryBudget)
  }
  
  var body: some View {
    HStack {
      // todayDailyStreakView
      DailyView(daily: dailyStreak[0])
        .background(
          RoundedRectangle(cornerRadius: 10)
            .stroke(.mainBright, lineWidth: 2)
        )
      
      // futureDailyStreakView
      HStack(spacing: 0) {
        ForEach(1..<6) { index in
          DailyView(daily: dailyStreak[index])
        }
      }
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(.whiteDeep50)
      )
    }
  }
}


// MARK: - DailyView
private struct DailyView: View {
  let daily: DailyStreak?
  
  var body: some View {
    VStack(spacing: 0) {
      switch daily?.time {
      case .today:
        todayContent
      case .future, .none:
        futureContent
      }
    }
    .padding(.top, 10)
    .frame(maxWidth: 50, maxHeight: 72)
  }
  
  private var todayContent: some View {
    VStack(spacing: 0) {
      Text("오늘")
        .font(.pretendardSemibold_12)
        .foregroundStyle(.main)
      
      Spacer()
      
      switch daily?.expenseType {
      case .empty:
        Image(.hexagonNone)
          .resizable()
          .frame(width: 20, height: 20)
      case .good:
        Image(.hexagonGood)
          .resizable()
          .frame(width: 20, height: 20)
      case .bad:
        Image(.hexagonBad)
          .resizable()
          .frame(width: 20, height: 20)
      case .none:
        Image(.hexagonNone)
          .resizable()
          .frame(width: 20, height: 20)
      }
      
      Spacer()
    }
  }
  
  private var futureContent: some View {
    VStack(spacing: 0) {
      Text(
        daily?.date.formattedDateToString(.dayWeekday) ?? ""
      )
        .font(.pretendardSemibold_12)
        .foregroundStyle(.textBright)
      
      Spacer()
      
      AmountText(amount: daily?.harubee ?? 0)
        .font(.pretendardMedium_12)
        .foregroundStyle(
          daily?.isAdjustedHarubee == true
          ? .main
          : .textBlack
        )
        .lineLimit(1)
      
      Spacer()
    }
  }
}


// MARK: - FooterView
private struct FooterView: View {
  let salaryBudget: SalaryBudget?
  
  private var title: String {
    self.getTitle()
  }
  
  private var harubee: Int {
    self.getTodayHarubee()
  }
  
  var body: some View {
    HStack {
      TodayHarubeeTextView(
        title: title,
        harubee: harubee,
        contentSize: .second
      )
      
      Spacer()
      
      ExpenseInputButton(title: "실제 지출 및 수입 입력하기")
    }
    .padding(.leading, 2)
  }
  
  private func getTitle() -> String {
    let dailyBudget = salaryBudget?.dailyBudgets.first(where: {
      $0.date == Date().formattedDate
    })
    
    return dailyBudget?.expense == nil
    ? "오늘의 하루비"
    : "오늘의 남은 하루비"
  }
  
  private func getTodayHarubee() -> Int {
    let dailyBudget = salaryBudget?.dailyBudgets.first(where: {
      $0.date == Date().formattedDate
    })
    
    let harubee = dailyBudget?.harubee ?? (Int(salaryBudget?.defaultHarubee ?? 0))
    
    let expenseSum = dailyBudget?.expense ?? 0
    
    return harubee - expenseSum
  }
}


// MARK: - Preview

#Preview("SystemMedium", as: .systemMedium) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(
    date: .now,
    salaryBudget: SalaryBudget.default
  )
}

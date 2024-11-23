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
    .padding(16)
  }
}


private struct BodyView: View {
  let salaryBudget: SalaryBudget?
  
  private var dailyStreak: [DailyStreak] {
    self.getDailyStreak()
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
  
  private func getDailyStreak() -> [DailyStreak] {
    return DailyStreak.mock
  }
}

private struct DailyView: View {
  let daily: DailyStreak
  
  var body: some View {
    VStack(spacing: 0) {
      switch daily.time {
      case .today:
        todayContent
      case .future:
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
      
      switch daily.expenseType {
      case .empty:
        Image(.hexagonNone)
          .resizable()
          .frame(width: 20, height: 20)
      case .good:
        Image(.hexagonNone)
          .resizable()
          .frame(width: 20, height: 20)
      case .bad:
        Image(.hexagonNone)
          .resizable()
          .frame(width: 20, height: 20)
      }
      
      Spacer()
    }
  }
  
  private var futureContent: some View {
    VStack(spacing: 0) {
      Text(daily.date.formattedDateToString(.dayWeekday))
        .font(.pretendardSemibold_12)
        .foregroundStyle(.textBright)
      
      Spacer()
      
      ViewThatFits {
        Text(daily.harubee.decimal)
          .font(.pretendardMedium_12)
        
        Text(daily.harubee.formattedAsTenThousandWon)
          .font(.pretendardMedium_12)
      }
      .foregroundStyle(
        daily.isAdjustedHarubee == true
        ? .main
        : .textBlack
      )
      .lineLimit(1)
      
      Spacer()
    }
  }
}

private struct FooterView: View {
  let salaryBudget: SalaryBudget?
  
  var body: some View {
    HStack(spacing: 37) {
      footerTextView
      
      ExpenseInputButton(title: "실제 지출 및 수입 입력하기")
    }
    .padding(.leading, 2)
  }
  
  private var footerTextView: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("오늘의 하루비")
        .font(.pretendardMedium_12)
        .foregroundStyle(.textBright)
      
      TodayHarubeeTextView(
        text: 99999.decimalWithWon,
        contentSize: .second
      )
    }
  }
}

private struct DailyStreak: Hashable {
  enum Time {
    case today
    case future
  }
  
  enum ExpenseType {
    case empty
    case good
    case bad
  }
  
  let date: Date
  let time: Time
  let harubee: Int
  let isAdjustedHarubee: Bool
  let expenseType: ExpenseType
  
  init(
    date: Date,
    time: Time,
    harubee: Int,
    isAdjustedHarubee: Bool = false,
    expenseType: ExpenseType = .empty
  ) {
    self.date = date
    self.time = time
    self.harubee = harubee
    self.isAdjustedHarubee = isAdjustedHarubee
    self.expenseType = expenseType
  }
  
  static let mock: [Self] = [
    .init(
      date: .now,
      time: .today,
      harubee: 130000,
      expenseType: .empty
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 1),
      time: .future,
      harubee: 99999,
      isAdjustedHarubee: true
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 2),
      time: .future,
      harubee: 999999
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 4),
      time: .future,
      harubee: 100000
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 5),
      time: .future,
      harubee: 100000
    ),
    .init(
      date: .now.addingTimeInterval(86400 * 6),
      time: .future,
      harubee: 100000
    )
  ]
}


// MARK: - Preview

#Preview("SystemMedium", as: .systemMedium) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(date: .now, salaryBudget: SalaryBudget.default)
}

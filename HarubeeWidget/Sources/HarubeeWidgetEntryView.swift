//
//  HarubeeWidgetEntryView.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/21/24.
//

import SwiftUI
import WidgetKit

struct HarubeeWidgetEntryView : View {
  @Environment(\.widgetFamily) private var widgetFamily
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      SystemSmallWidgetView(entry: entry)
    case .systemMedium:
      SystemMediumWidgetView(entry: entry)
    default:
      EmptyView()
    }
  }
}

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

// MARK: - SystemMediumWidgetView
struct SystemMediumWidgetView: View {
  struct DailyStreak {
    let date: Date
    let isAfterToday: Bool
    let harubee: Int
    let isOverHarubee: Bool?
  }
  
  let entry: Provider.Entry
  
  private var dailyStreak: [DailyStreak] {
    self.getDailyStreak()
  }
  
  var body: some View {
    VStack {
      
      bodyView
      
      Spacer()
      
      HStack(spacing: 37) {
        footerTextView
        
        ExpenseInputButton(title: "실제 지출 및 수입 입력하기")
      }
      .padding(.leading, 2)
      
    }
    .padding(16)
  }
  
  private var bodyView: some View {
    HStack {
      Text("1")
      Spacer()
      Text("2")
    }
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
  
  private func getDailyStreak() -> [DailyStreak] {
    return []
  }
}

// MARK: - TodayHarubeeTextView
private struct TodayHarubeeTextView: View {
  
  enum ContentSize {
    case first
    case second
    
    var font: Font {
      switch self {
      case .first: .pretendardSemibold_20
      case .second: .pretendardSemibold_18
      }
    }
    
    var imageSize: CGFloat {
      switch self {
      case .first: 18
      case .second: 16
      }
    }
  }
  
  let text: String
  let contentSize: ContentSize
  
  var body: some View {
    HStack {
      Image(.harubeeMain)
        .resizable()
        .frame(
          width: contentSize.imageSize,
          height: contentSize.imageSize
        )
      
      Text(text)
        .font(contentSize.font)
        .foregroundStyle(.main)
    }
  }
}

// MARK: - ExpenseInputButton
private struct ExpenseInputButton: View {
  let title: String
  
  var body: some View {
    Button {
      
    } label: {
      Text(title)
        .font(.pretendardSemibold_12)
        .foregroundStyle(.whiteDefault)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 13)
        .background(.main)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    .buttonStyle(.plain)
  }
}


// MARK: - Preview

#Preview("SystemMedium", as: .systemMedium) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(date: .now, salaryBudget: SalaryBudget.default)
}

#Preview("SystemSmall", as: .systemSmall) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(date: .now, salaryBudget: SalaryBudget.default)
}


//
//  CalendarCell.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Domain

struct CalendarCell: View {
  // MARK: - Types
  private enum CellStatus {
    case today(isAdjusted: Bool)
    case overBudget
    case underBudget
    case noExpense
    case past
    
    var icon: Image {
      switch self {
      case .overBudget: return .hexagoneBad
      case .underBudget: return .hexagoneGood
      case .today: return .hexagonNone
      case .noExpense, .past: return Image(uiImage: UIImage())
      }
    }
    
    var amountColor: Color {
      switch self {
      case .past:
        return .textBright
      case .today(let hasCustomHarubee) where !hasCustomHarubee:
        return .textBlack
      default:
        return .main
      }
    }
  }
  
  // MARK: - Properties
  let date: Date
  let defaultHarubee: Int
  let dailyBudget: DailyBudget?
  let onSelect: (Date) -> Void
  
  // MARK: - Computed Properties
  private var status: CellStatus {
    if date.isToday {
      return .today(isAdjusted: dailyBudget?.harubee != nil)
    }
    
    if date <= Date() {
      if let expense = dailyBudget?.expense {
        if expense > (dailyBudget?.harubee ?? defaultHarubee) {
          return .overBudget
        }
        return .underBudget
      }
      return .past
    }
    
    return .noExpense
  }
  
  private var amount: Int {
    if date <= Date(), let expense = dailyBudget?.expense {
      return expense
    }
    return dailyBudget?.harubee ?? defaultHarubee
  }
  
  // MARK: - Body
  var body: some View {
    VStack(spacing: 0) {
      dateLabel
      iconSection
      amountLabel
    }
    .frame(height: 90)
    .frame(maxWidth: .infinity)
    .background(cellBackground)
    .tapFeedback {
      onSelect(date)
    }
    .padding(.vertical, 10)
  }
  
  // MARK: - Subviews
  private var dateLabel: some View {
    Text(date.calendarDayText)
      .font(.pretendardSemibold_14)
      .foregroundStyle(Color.textBlack)
      .padding(.top, 5)
  }
  
  private var iconSection: some View {
    status.icon
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 23, height: 23)
      .frame(maxHeight: .infinity)
  }
  
  private var amountLabel: some View {
    Text(amount.formatted(.number))
      .font(.pretendardMedium_11)
      .foregroundStyle(status.amountColor)
      .padding(.bottom, 5)
  }
  
  private var cellBackground: some View {
    RoundedRectangle(cornerRadius: 5)
      .fill(date.isToday ? Color.whiteDeep50 : .whiteDefault)
      .stroke(date.isToday ? Color.mainBright : Color.clear, lineWidth: 1)
      .padding(1)
  }
}

// MARK: - Preview
struct CalendarCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      // 오늘 - 지출 없음
      CalendarCell(
        date: Date(),
        defaultHarubee: 10000,
        dailyBudget: DailyBudget(
          date: Date(),
          harubee: 10000,
          memo: [],
          expense: nil,
          income: nil
        ),
        onSelect: { _ in }
      )
      .previewDisplayName("Today - No Expense")
      
      // 오늘 - 예산 초과
      CalendarCell(
        date: Date(),
        defaultHarubee: 10000,
        dailyBudget: DailyBudget(
          date: Date(),
          harubee: 10000,
          memo: [],
          expense: 12000,
          income: 1000
        ),
        onSelect: { _ in }
      )
      .previewDisplayName("Today - Over Budget")
      
      // 오늘 - 예산 이하
      CalendarCell(
        date: Date(),
        defaultHarubee: 10000,
        dailyBudget: DailyBudget(
          date: Date(),
          harubee: 10000,
          memo: [],
          expense: 8000,
          income: nil
        ),
        onSelect: { _ in }
      )
      .previewDisplayName("Today - Under Budget")
    }
    .frame(width: 50)
  }
}

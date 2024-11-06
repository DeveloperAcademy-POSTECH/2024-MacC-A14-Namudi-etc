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
  // MARK: - Properties
  let onSelect: (Date) -> Void
  let date: Date
  let defaultHarubee: Int
  let dailyBudget: DailyBudget?
  
  // MARK: - Computed Properties
  private var isOverHarubee: Bool {
    guard let budget = dailyBudget,
          let expense = budget.expense,
          let harubee = budget.harubee else { return false }
    return expense > harubee
  }
  
  private var hasExpense: Bool {
    guard let budget = dailyBudget,
          let expense = budget.expense else { return false }
    return expense > 0
  }
  
  private var amountText: String {
    guard let budget = dailyBudget else { return "0" }
    
    if date <= Date(), let expense = budget.expense {
      return expense.formatted(.number)
    } else {
      return (budget.harubee ?? defaultHarubee).formatted(.number)
    }
  }
  
  private var amountColor: Color {
    if !date.isToday && date <= Date() {
      return .textBright
    }
    if dailyBudget?.harubee != nil {
      return .main
    }
    return .textBlack
  }
  
  private var statusIcon: Image {
    guard let _ = dailyBudget else { return .hexagonNone }
    
    if hasExpense && isOverHarubee {
      return .hexagoneBad
    }
    if hasExpense && !isOverHarubee {
      return .hexagoneGood
    }
    if date.isToday {
      return .hexagonNone
    }
    
    return Image(uiImage: UIImage())
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
    statusIcon
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 23, height: 23)
      .frame(maxHeight: .infinity)
  }
  
  private var amountLabel: some View {
    Text(amountText)
      .font(.pretendardMedium_11)
      .foregroundStyle(amountColor)
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
#Preview {
  CalendarCell(
    onSelect: {_ in },
    date: Date(),
    defaultHarubee: 10000,
    dailyBudget: DailyBudget(
      date: Date(),
      harubee: 10000,
      memo: [],
      expense: nil,
      income: nil
    )
  )
  .frame(width: 50)
}

#Preview {
  CalendarCell(
    onSelect: {_ in },
    date: Date(),
    defaultHarubee: 10000,
    dailyBudget: DailyBudget(
      date: Date(),
      harubee: 10000,
      memo: [],
      expense: 12000,
      income: 1000
    )
  )
  .frame(width: 50)
}

#Preview {
  CalendarCell(
    onSelect: {_ in },
    date: Date(),
    defaultHarubee: 10000,
    dailyBudget: DailyBudget(
      date: Date(),
      harubee: 10000,
      memo: [],
      expense: 8000,
      income: nil
    )
  )
  .frame(width: 50)
}

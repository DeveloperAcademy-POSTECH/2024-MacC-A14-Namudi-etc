//
//  CalendarCell.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct CalendarCell: View {
  let date: Date
  let dayInfo: CalendarData.DayInfo?
  
  var body: some View {
    VStack(spacing: 0) {
      dateLabel
      statusIcon
      amountLabel
    }
    .frame(height: 90)
    .frame(maxWidth: .infinity)
    .background(cellBackground)
    .padding(.vertical, 10)
  }
  
  private var dateLabel: some View {
    Text(date.calendarDayText)
      .font(.pretendardSemibold_14)
      .foregroundStyle(Color.textBlack)
      .padding(.top, 5)
  }
  
  private var statusIcon: some View {
    hexagonIcon
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
      .fill(backgroundColor)
      .stroke(date.isToday ? Color.mainBright : Color.clear, lineWidth: 1)
      .padding(1)
  }
}

// MARK: - Computed Properties
private extension CalendarCell {
  var hexagonIcon: Image {
    guard let dayInfo = dayInfo else { return .hexagonNone }
    
    if dayInfo.hasExpense && dayInfo.isOverHarubee {
      return .hexagoneBad
    }
    if dayInfo.hasExpense && !dayInfo.isOverHarubee {
      return .hexagoneGood
    }
    if dayInfo.date.isToday {
      return .hexagonNone
    }
    
    return Image("")
  }
  
  var amountText: String {
    guard let info = dayInfo else { return "0" }
    return (date <= Date() && info.expense != nil)
    ? (info.expense?.formatted(.number) ?? "0")
    : info.harubee.formatted(.number)
  }
  
  var amountColor: Color {
    if !date.isToday && date <= Date() {
      return .textBright
    }
    if dayInfo?.isAdjusted == true {
      return .main
    }
    return .textBlack
  }
  
  var backgroundColor: Color {
    return date.isToday ? .whiteDeep50 : .whiteDefault
  }
}

#Preview {
  CalendarCell(
    date: Date(),
    dayInfo: CalendarData.DayInfo.init(
    date: Date(),
    harubee: 10000,
    isAdjusted: true,
    income: nil,
    expense: nil,
    memos: [],
    fixedExpenses: []
    )
  )
  .frame(width: 50)
}

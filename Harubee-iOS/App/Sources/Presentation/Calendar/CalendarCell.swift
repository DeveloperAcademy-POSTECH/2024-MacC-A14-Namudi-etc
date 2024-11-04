//
//  CalendarCell.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Calendar Cell
struct CalendarCell: View {
  let date: Date
  let dayInfo: CalendarData.DayInfo?
  let isSelected: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      Text(dayText)
        .font(.pretendardMedium_14)
        .foregroundStyle(dayTextColor)
        .padding(.top, 5)
      
      hexagonView
      
      Text(amountDisplayText)
        .font(.pretendardMedium_12)
        .foregroundStyle(amountTextColor)
        .padding(.bottom, 5)
    }
    .frame(height: 90)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 5)
        .fill(backgroundColor)
        .stroke(
          date.isToday ? Color.mainBright : Color.clear, lineWidth: 1
        )
        .padding(1)
    )
    .padding(.vertical, 10)
  }
  
  private var hexagonView: some View {
    Group {
      if let image = hexagonImage {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else {
        Spacer()
      }
    }
    .frame(width: 23, height: 23)
    .frame(maxHeight: .infinity)
  }
  
  private var dayText: String {
    date.calendarDayText
  }
  
  private var amountDisplayText: String {
    guard let info = dayInfo else { return "0" }
    
    if date <= Date() && info.expense != nil {
      return info.expense?.formatted(.number) ?? "0"
    }
    return info.harubee.formatted(.number)
  }
  
  private var dayTextColor: Color {
    if isSelected {
      return .whiteDefault
    }
    return .textBlack
  }
  
  private var amountTextColor: Color {
    if isSelected {
      return .whiteDefault
    } else if !date.isToday && date <= Date() {
      return .textBright
    } else if dayInfo?.isAdjusted ?? false {
      return .mainBright
    }
    return .textBlack
  }
  
  private var backgroundColor: Color {
    if isSelected {
      return .main
    } else if date.isToday {
      return .whiteDeep50
    }
    return .whiteDefault
  }
  
  private var hexagonImage: Image? {
    guard let info = dayInfo else { return nil }
    
    if info.isOverHarubee && info.hasExpense {
      return Image.hexagoneBad
    } else if !info.isOverHarubee && info.hasExpense {
      return Image.hexagoneGood
    } else if date.isToday && isSelected {
      return Image.hexagoneGood.foregroundStyle(Color.whiteDefault) as? Image
    } else {
      return Image.hexagonNone
    }
  }
}

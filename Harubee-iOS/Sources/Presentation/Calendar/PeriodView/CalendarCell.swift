//
//  CalendarCell.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - Calendar Cell
struct CalendarCell: View {
  private let date: Date
  private let isSelected: Bool
  private let isToday: Bool
  private let dayInfo: DayInfo?
  
  private var dayText: String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)
    let month = calendar.component(.month, from: date)
    return day == 1 ? "\(month)/\(day)" : "\(day)"
  }
  
  private var amountText: String {
    (dayInfo?.harubee ?? 0).formatted(.number)
  }
  
  private var dayTextColor: Color {
    if isSelected || isToday {
      return .whiteDefault
    }
    return .textBlack
  }
  
  private var amountTextColor: Color {
    if isSelected || isToday {
      return .whiteDefault
    } else if !isToday && date <= Date() {
      return .textBright
    } else if let info = dayInfo, info.isAdjusted {
      return .mainBright
    }
    return .textBlack
  }
  
  private var backgroundColor: Color {
    if isSelected {
      return .main
    } else if isToday {
      return .mainBright
    } else {
      return .whiteDefault
    }
  }
  
  private var hexagonImage: ImageResource? {
    guard let info = dayInfo else { return nil }
    
    if info.isOverHarubee && info.hasExpense {
      return .hexagonBad
    } else if !info.isOverHarubee && info.hasExpense {
      return .hexagonGood
    } else if isToday {
      return .hexagonNone
    } else {
      return nil
    }
  }
  
  init(
    date: Date,
    isSelected: Bool,
    isToday: Bool,
    dayInfo: DayInfo?
  ) {
    self.date = date
    self.isSelected = isSelected
    self.isToday = isToday
    self.dayInfo = dayInfo
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(dayText)
        .font(.pretendardMedium_14)
        .foregroundStyle(dayTextColor)
        .padding(.top, 5)
      
      Group {
        if let image = hexagonImage {
          Image(image)
            .resizable()
        } else {
          Spacer()
        }
      }
      .frame(width: 23, height: 23)
      .frame(maxHeight: .infinity)
      
      Text(amountText)
        .font(.pretendardMedium_12)
        .foregroundStyle(amountTextColor)
        .padding(.bottom, 5)
    }
    .frame(height: 90)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 5)
        .fill(backgroundColor)
        .padding(1)
    )
    .padding(.vertical, 10)
    .contentShape(Rectangle())
  }
}

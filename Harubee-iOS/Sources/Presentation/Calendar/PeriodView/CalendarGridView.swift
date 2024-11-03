//
//  CalendarGridView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - Calendar Grid View
struct CalendarGridView: View {
  private let daysInPeriod: [Date?]
  private let selectedDate: Date?
  private let dayInfos: [DayInfo]
  private let onDateSelected: (Date) -> Void
  
  private var weeks: [[Date?]] {
    stride(from: 0, to: daysInPeriod.count, by: 7).map {
      Array(daysInPeriod[$0..<min($0 + 7, daysInPeriod.count)])
    }
  }
  
  init(
    daysInPeriod: [Date?],
    selectedDate: Date?,
    dayInfos: [DayInfo],
    onDateSelected: @escaping (Date) -> Void
  ) {
    self.daysInPeriod = daysInPeriod
    self.selectedDate = selectedDate
    self.dayInfos = dayInfos
    self.onDateSelected = onDateSelected
  }
  
  var body: some View {
    VStack(spacing: 0) {
      WeekdayHeaderView()
        .padding(.bottom, 8)
      
      VStack(spacing: 0) {
        ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
          VStack(spacing: 8) {
            LazyVGrid(
              columns: Array(
                repeating: .init(.flexible(), spacing: 0),
                count: 7
              ),
              spacing: 0
            ) {
              ForEach(Array(week.enumerated()), id: \.offset) { _, date in
                if let validDate = date {
                  CalendarCell(
                    date: validDate,
                    isSelected: Calendar.current.isDate(
                      validDate,
                      inSameDayAs: selectedDate ?? Date()
                    ),
                    isToday: Calendar.current.isDateInToday(validDate),
                    dayInfo: dayInfos.first {
                      Calendar.current.isDate($0.date, inSameDayAs: validDate)
                    }
                  )
                  .onTapGesture {
                    onDateSelected(validDate)
                  }
                } else {
                  Color.clear.frame(height: 90)
                }
              }
            }
            
            if index < weeks.count - 1 {
              Divider()
                .background(Color.textBlack10)
                .padding(.horizontal, -14)
                .frame(height: 1)
            }
          }
        }
      }
    }
  }
}

// Weekday Header View
private struct WeekdayHeaderView: View {
  private let weekDays: [String] = [
    "일", "월", "화", "수", "목", "금", "토"
  ]
  
  var body: some View {
    VStack {
      HStack(spacing: 0) {
        ForEach(weekDays, id: \.self) { symbol in
          Text(symbol)
            .font(.pretendardMedium_16)
            .foregroundStyle(Color.textBlack)
            .frame(maxWidth: .infinity)
        }
      }
      
      Divider()
        .background(Color.textBlack10)
        .padding(.horizontal, -14)
        .frame(height: 1/UIWindow().screen.scale)
    }
  }
}

#Preview {
  NavigationStack {
    CalendarView(viewModel: DIContainer.shared.makeCalendarViewModel()
    )
  }
}

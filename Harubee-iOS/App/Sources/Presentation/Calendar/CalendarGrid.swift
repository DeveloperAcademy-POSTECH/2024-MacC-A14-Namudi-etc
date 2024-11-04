//
//  CalendarGrid.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Calendar Grid Component
struct CalendarGrid<CellContent: View>: View {
  private let startDate: Date
  private let endDate: Date
  private let selectedDate: Date?
  private let onCellSelect: (Date) -> Void
  private let cellContent: (Date) -> CellContent
  
  init(
    startDate: Date,
    endDate: Date,
    selectedDate: Date? = nil,
    onCellSelect: @escaping (Date) -> Void,
    @ViewBuilder cellContent: @escaping (Date) -> CellContent
  ) {
    self.startDate = startDate
    self.endDate = endDate
    self.selectedDate = selectedDate
    self.onCellSelect = onCellSelect
    self.cellContent = cellContent
  }
  
  var body: some View {
    VStack(spacing: 0) {
      WeekdayHeaderRow()
        .padding(.bottom, 8)
      
      LazyVStack(spacing: 0) {
        ForEach(weeks.indices, id: \.self) { weekIndex in
          WeekRow(
            week: weeks[weekIndex],
            isLastRow: weekIndex == weeks.count - 1,
            selectedDate: selectedDate,
            onDateSelect: onCellSelect,
            cellContent: cellContent
          )
        }
      }
    }
    .padding(.horizontal, 14)
  }
  
  // MARK: - Computed Properties
  private var weeks: [[Date?]] {
    createDaysInPeriod().chunked(into: 7)
  }
  
  // MARK: - Helper Methods
  private func createDaysInPeriod() -> [Date?] {
    let calendar = Calendar.current
    var dates: [Date?] = []
    
    // 저번 기간 마지막 주, 이번 기간 leading 빈 셀 생성
    let startWeekday = calendar.component(.weekday, from: startDate) - 1
    dates += Array(repeating: nil as Date?, count: startWeekday)
    
    // 이번 기간 셀 생성
    var currentDate = startDate
    while currentDate <= endDate {
      dates.append(currentDate)
      guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
      currentDate = nextDate
    }
    
    // 다음 기간 첫째 주, 이번 기간 trailing 빈 셀 생성
    let remainingDays = (7 - (dates.count % 7)) % 7
    dates += Array(repeating: nil as Date?, count: remainingDays)
    
    return dates
  }
}

// MARK: - Weekday Header Row
private struct WeekdayHeaderRow: View {
  private let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(weekDays, id: \.self) { day in
        Text(day)
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.textBlack)
          .frame(maxWidth: .infinity)
      }
    }
    .overlay(alignment: .bottom) {
      Divider()
        .background(Color.textBlack10)
        .padding(.top, 20)
        .padding(.horizontal, -14)
        .frame(height: 1)
    }
  }
}

// MARK: - Week Row
private struct WeekRow<CellContent: View>: View {
  let week: [Date?]
  let isLastRow: Bool
  let selectedDate: Date?
  let onDateSelect: (Date) -> Void
  let cellContent: (Date) -> CellContent
  
  var body: some View {
    VStack(spacing: 0) {
      LazyVGrid(
        columns: Array(
          repeating: .init(.flexible(), spacing: 0), count: 7
        ),
        spacing: 0
      ) {
        ForEach(week.indices, id: \.self) { index in
          if let date = week[index] {
            cellContent(date)
              .contentShape(Rectangle())
              .onTapGesture { onDateSelect(date) }
          } else {
            Color.clear
              .frame(height: 90)
          }
        }
      }
      
      if !isLastRow {
        Divider()
          .background(Color.textBlack10)
          .padding(.horizontal, -14)
          .frame(height: 1)
      }
    }
  }
}

// MARK: - Array Extension
private extension Array {
  func chunked(into size: Int) -> [[Element]] {
    stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }
}

// MARK: - Preview
#Preview {
  let current = Calendar.current
  
  CalendarGrid(
    startDate: Date(),
    endDate: current.date(
      byAdding: .month, value: 1, to: Date()
    )! - 1,
    selectedDate: Date(),
    onCellSelect: { _ in }
  ) { date in
    VStack {
      Text("\(current.component(.day, from: date))")
        .frame(height: 90)
      Text("TEST")
    }
  }
}

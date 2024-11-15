//
//  CalendarGrid.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Periodly Calendar Component
struct PeriodlyCalendar<CellContent: View>: View {
  let startDate: Date
  let endDate: Date
  let cellContent: (Date) -> CellContent
  
  @State private var isScrollDisabled: Bool = true
  
  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        LazyVStack(spacing: 0) {
          ForEach(weeks.indices, id: \.self) { weekIndex in
            WeekRow(
              week: weeks[weekIndex],
              isLastRow: weekIndex == weeks.count - 1,
              cellContent: cellContent
            )
          }
        }
      }
      .padding(.horizontal, 14)
    }
    .scrollDisabled(isScrollDisabled)
    .onAppear {
      updateScrollState()
    }
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
  
  private func updateScrollState() {
    isScrollDisabled = weeks.count < 6
  }
}

// MARK: - Week Row
private struct WeekRow<CellContent: View>: View {
  let week: [Date?]
  let isLastRow: Bool
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
  
  PeriodlyCalendar(
    startDate: Date(),
    endDate: current.date(
      byAdding: .month, value: 1, to: Date()
    )! - 1
  ) { date in
    VStack {
      Text("\(current.component(.day, from: date))")
        .frame(height: 90)
      Text("TEST")
    }
  }
}

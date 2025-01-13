//
//  WeeklyCalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/8/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - WeeklyCalendar
struct WeeklyCalendar: View {
  let selectedDate: Date
  let budget: SalaryBudget
  let onSelect: (Date) -> Void
  
  private let daysInWeek = 7
  
  var body: some View {
    GeometryReader { proxy in
      let layout = WeeklyLayout(
        availableWidth: proxy.size.width,
        daysCount: daysInWeek
      )
      
      ScrollView(.horizontal, showsIndicators: false) {
        ScrollViewReader { scrollProxy in
          LazyHStack(spacing: 0) {
            ForEach(weeks.indices, id: \ .self) { weekIndex in
              WeekRow(
                dates: weeks[weekIndex],
                selectedDate: selectedDate,
                layout: layout,
                onSelect: onSelect,
                isLastWeek: weekIndex == weeks.count - 1,
                weekCount: weeks[weekIndex].count
              )
              .id(weekIndex)
            }
          }
          .onAppear { scrollToSelectedWeek(proxy: scrollProxy) }
          .onChange(of: selectedDate) { _, _ in
            scrollToSelectedWeek(proxy: scrollProxy)
          }
        }
      }
      .scrollTargetBehavior(.paging)
    }
    .background(.bgAccent)
  }
  
  private var weeks: [[Date]] {
    let calendar = Calendar.current
    let days = calendar.dateComponents([.day], from: budget.startDate, to: budget.endDate).day ?? 0
    
    let allDates = (0...days).compactMap {
      calendar.date(byAdding: .day, value: $0, to: budget.startDate)
    }
    return allDates.chunked(into: daysInWeek)
  }
  
  private func scrollToSelectedWeek(proxy: ScrollViewProxy) {
    if let weekIndex = weeks.firstIndex(where: { week in
      week.contains {
        Calendar.current.isDate($0, equalTo: selectedDate, toGranularity: .day)
      }
    }) {
      proxy.scrollTo(weekIndex, anchor: .center)
    }
  }
}

// MARK: - WeekRow
private struct WeekRow: View {
  let dates: [Date]
  let selectedDate: Date
  let layout: WeeklyLayout
  let onSelect: (Date) -> Void
  let isLastWeek: Bool
  let weekCount: Int
  
  var body: some View {
    GeometryReader { geometry in
      HStack(spacing: layout.cellSpacing) {
        ForEach(dates, id: \ .timeIntervalSince1970) { date in
          WeekDayCell(
            date: date,
            isSelected: Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .day),
            width: layout.cellWidth,
            onSelect: onSelect
          )
        }
      }
      .padding(.horizontal, layout.horizontalPadding)
      .padding(.bottom, 6)
      .frame(maxWidth: geometry.size.width, alignment: alignment)
      .frame(height: geometry.size.height, alignment: .bottom)
    }
    .frame(width: layout.containerWidth)
  }
  
  private var alignment: Alignment {
    isLastWeek && weekCount < 7 ? .leading : .center
  }
}

// MARK: - WeekDayCell
private struct WeekDayCell: View {
  let date: Date
  let isSelected: Bool
  let width: CGFloat
  let onSelect: (Date) -> Void
  
  var body: some View {
    VStack(spacing: 0) {
      Text(weekday)
        .font(.pretendardMedium_14)
        .foregroundStyle(.textFixed)
        .padding(.bottom, 9)
      
      ZStack {
        if isSelected {
          Circle()
            .fill(.textFixed)
            .frame(width: circleSize, height: circleSize)
            .transition(.scale.combined(with: .opacity))
        } else if date.isToday {
          Circle()
            .stroke(.textFixed, lineWidth: 1)
            .frame(width: circleSize, height: circleSize)
        }
        
        Text(day)
          .font(.pretendardSemibold_16)
          .foregroundStyle(isSelected ? .dayText : .textFixed)
      }
      .frame(width: circleSize, height: circleSize)
      .animation(.spring(duration: 0.2), value: isSelected)
    }
    .frame(width: width, height: 68)
    .onTapGesture {
      onSelect(date)
    }
  }
  
  private var weekday: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "E"
    return formatter.string(from: date)
  }
  
  private var day: String {
    "\(Calendar.current.component(.day, from: date))"
  }
  
  private let circleSize: CGFloat = 30
}

// MARK: - WeeklyLayout
private struct WeeklyLayout {
  let containerWidth: CGFloat
  let cellWidth: CGFloat
  let cellSpacing: CGFloat
  let horizontalPadding: CGFloat
  
  init(availableWidth: CGFloat, daysCount: Int) {
    containerWidth = availableWidth
    horizontalPadding = 21
    cellSpacing = 14
    
    let usableWidth = availableWidth - (horizontalPadding * 2)
    let totalSpacing = cellSpacing * CGFloat(daysCount - 1)
    cellWidth = (usableWidth - totalSpacing) / CGFloat(daysCount)
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

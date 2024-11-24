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
            ForEach(weeks.indices, id: \.self) { weekIndex in
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
          .scrollTargetLayout()
          .onAppear { scrollToSelectedWeek(proxy: scrollProxy) }
          .onChange(of: selectedDate) { _, _ in
            scrollToSelectedWeek(proxy: scrollProxy)
          }
        }
      }
      .scrollTargetBehavior(.paging)
    }
    .background(Color.main)
  }
  
  private var weeks: [[Date]] {
    let calendar = Calendar.current
    let days = calendar.dateComponents([.day], from: budget.startDate, to: budget.endDate).day ?? 0
    
    let allDates = (0...days).compactMap { offset in
      calendar.date(byAdding: .day, value: offset, to: budget.startDate)
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
  
  private let daysInWeek = 7
  
  var body: some View {
    GeometryReader { geometry in
      let totalCellWidth = layout.cellWidth * CGFloat(weekCount)
      let totalSpacing = layout.cellSpacing * CGFloat(max(0, weekCount - 1))
      let contentWidth = totalCellWidth + totalSpacing + (layout.horizontalPadding * 2)
      
      HStack(spacing: layout.cellSpacing) {
        ForEach(dates, id: \.timeIntervalSince1970) { date in
          WeekDayCell(
            date: date,
            isSelected: Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .day),
            width: layout.cellWidth,
            onSelect: onSelect
          )
        }
      }
      .padding(.horizontal, layout.horizontalPadding)
      .frame(width: contentWidth)
      .frame(maxWidth: geometry.size.width, alignment: shouldAlignLeft ? .leading : .center)
      .frame(maxHeight: .infinity)
      .contentShape(Rectangle())
    }
    .frame(width: layout.containerWidth)
  }
  
  private var shouldAlignLeft: Bool {
    isLastWeek && weekCount < daysInWeek
  }
}

// MARK: - WeekDayCell
private struct WeekDayCell: View {
  let date: Date
  let isSelected: Bool
  let width: CGFloat
  let onSelect: (Date) -> Void
  
  var body: some View {
    VStack(spacing: 9) {
      Text(weekday)
        .font(.pretendardMedium_14)
        .foregroundStyle(Color.whiteDefault)
      
      ZStack {
        if isSelected {
          Circle()
            .fill(Color.whiteDefault)
            .frame(width: circleSize, height: circleSize)
            .transition(.scale.combined(with: .opacity))
        } else if date.isToday {
          Circle()
            .stroke(Color.whiteDefault, lineWidth: 1)
            .frame(width: circleSize, height: circleSize)
        }
        
        Text(day)
          .font(.pretendardSemibold_16)
          .foregroundStyle(isSelected ? Color.main : .whiteDefault)
      }
      .frame(width: circleSize, height: circleSize)
      .animation(.spring(duration: 0.2), value: isSelected)
    }
    .frame(width: width, height: 64)
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
  
  private var circleSize: CGFloat {
    min(30, width * 0.7)
  }
}

// MARK: - WeeklyLayout
private struct WeeklyLayout {
  let containerWidth: CGFloat
  let cellWidth: CGFloat
  let cellSpacing: CGFloat
  let horizontalPadding: CGFloat
  
  init(availableWidth: CGFloat, daysCount: Int) {
    containerWidth = availableWidth
    horizontalPadding = 16
    cellSpacing = 8
    
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

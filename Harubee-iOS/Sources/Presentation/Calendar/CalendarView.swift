//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - Calendar View
struct CalendarView: View {
  @State private var selectedDate = Date()
  @State private var currentPeriod: (start: Date, end: Date) = {
    let calendar = Calendar.current
    let today = Date()
    let components = calendar.dateComponents([.year, .month], from: today)
    let startDate = calendar.date(from: DateComponents(year: components.year, month: components.month, day: 20))!
    
    return (
      startDate,
      calendar.date(byAdding: .month, value: 1, to: startDate)!.addingTimeInterval(-86400)
    )
  }()
  
  var body: some View {
    ZStack {
      Color.whiteDefault
      VStack(spacing: 0) {
        CalendarHeaderView(
          periodYearTitle: periodYearTitle,
          periodTitle: periodTitle,
          selectedDate: $selectedDate
        )
        
        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            CalendarGridView(
              daysInPeriod: daysInPeriod,
              selectedDate: selectedDate,
              onDateSelected: {
                selectedDate = $0
              }
            )
            .padding(.top, 18)
            .padding(.horizontal, 14)
          }
        }
      }
    }
    .navigationTitle("캘린더")
    .navigationBarTitleDisplayMode(.inline)
  }
}

// MARK: - Calendar Header View
private struct CalendarHeaderView: View {
  let periodYearTitle: String
  let periodTitle: String
  @Binding var selectedDate: Date
  
  private enum NavigationDirection {
    case forward, backward
    
    var imageName: String {
      switch self {
      case .forward: return "chevron.right"
      case .backward: return "chevron.left"
      }
    }
  }
  
  var body: some View {
    VStack(spacing: 3) {
      Text(periodYearTitle)
        .font(.pretendardMedium_12)
      
      HStack(spacing: 38) {
        navigationButton(direction: .backward)
        Text(periodTitle)
          .font(.pretendardSemibold_24)
        navigationButton(direction: .forward)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 22)
    .padding(.bottom, 15)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
  }
  
  private func navigationButton(direction: NavigationDirection) -> some View {
    Button {
      // TODO: Navigate to previous/next period
    } label: {
      Image(systemName: direction.imageName)
        .font(.custom("SF Pro", size: 16))
    }
  }
}

// MARK: - Calendar Grid View
private struct CalendarGridView: View {
  let daysInPeriod: [Date?]
  let selectedDate: Date
  let onDateSelected: (Date) -> Void
  
  private let weekDaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
  
  private var weeks: [[Date?]] {
    stride(from: 0, to: daysInPeriod.count, by: 7).map {
      Array(daysInPeriod[$0..<min($0 + 7, daysInPeriod.count)])
    }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      // Weekday Header
      VStack {
        HStack(spacing: 0) {
          ForEach(weekDaySymbols, id: \.self) { symbol in
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
      .padding(.bottom, 8)
      
      // Calendar Grid
      VStack(spacing: 8) {
        ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
          VStack(spacing: 0) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 7), spacing: 0) {
              ForEach(Array(week.enumerated()), id: \.offset) { _, date in
                if let validDate = date {
                  CalendarCell(
                    date: validDate,
                    isSelected: Calendar.current.isDate(validDate, inSameDayAs: selectedDate),
                    harubee: 50000
                  )
                  .onTapGesture {
                    withAnimation(.smooth) {
                      onDateSelected(validDate)
                    }
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
                .frame(height: 1/UIWindow().screen.scale)
            }
          }
        }
      }
    }
  }
}
// MARK: - Calendar Helper Properties
private extension CalendarView {
  var periodYearTitle: String {
    currentPeriod.start.formatted(.dateTime.year().locale(Locale(identifier: "ko_KR")))
      .replacingOccurrences(of: "년", with: "년")
  }
  
  var periodTitle: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M.d"
    return "\(formatter.string(from: currentPeriod.start)) - \(formatter.string(from: currentPeriod.end))"
  }
  
  var daysInPeriod: [Date?] {
    let calendar = Calendar.current
    var dates: [Date?] = []
    
    let startWeekday = calendar.component(.weekday, from: currentPeriod.start) - 1
    dates += Array(repeating: nil, count: startWeekday)
    
    var currentDate = currentPeriod.start
    while currentDate <= currentPeriod.end {
      dates.append(currentDate)
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    let remainingDays = (7 - (dates.count % 7)) % 7
    dates += Array(repeating: nil, count: remainingDays)
    
    return dates
  }
}

// MARK: - Calendar Cell View
private struct CalendarCell: View {
  let date: Date
  let isSelected: Bool
  let harubee: Int
  
  private var isToday: Bool {
    date == Calendar.current.startOfDay(for: Date())
  }
  
  private var isPast: Bool {
    date < Calendar.current.startOfDay(for: Date())
  }
  
  private var backgroundColor: Color {
    if isSelected {
      return .main
    } else if isToday {
      return .mainBright
    }
    return .whiteDefault
  }
  
  private var textColor: Color {
    if isSelected || isToday {
      return .whiteDefault
    }
    return .textBlack
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(dayText)
        .font(.pretendardMedium_14)
        .foregroundStyle(textColor)
        .padding(.top, 5)
      
      Spacer()
      
      Text(amountText)
        .font(.pretendardMedium_12)
        .foregroundStyle(textColor)
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

// MARK: - Calendar Cell Helper Properties
private extension CalendarCell {
  var dayText: String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)
    let month = calendar.component(.month, from: date)
    return day == 1 ? "\(month)/\(day)" : "\(day)"
  }
  
  var amountText: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: NSNumber(value: harubee)) ?? "0"
  }
}

// MARK: - Preview
#Preview {
  NavigationView {
    CalendarView()
  }
}

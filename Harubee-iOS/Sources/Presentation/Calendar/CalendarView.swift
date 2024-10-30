//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct CalendarView: View {
  
  @State private var selectedDate: Date = Date()
  
  @State private var currentPeriod: (start: Date, end: Date) = {
    let today = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: today)
    let startDate = calendar.date(from: DateComponents(year: components.year, month: components.month, day: 20))!
    let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
    return (startDate, endDate)
  }()
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 0) {
        CalendarHeaderView(
          periodTitle: periodTitle,
          selectedDate: $selectedDate
        )
        
        WeekdayHeaderView()
        
        CalendarGridView(
          daysInPeriod: daysInPeriod,
          selectedDate: selectedDate,
          onDateSelected: { date in
            selectedDate = date
          }
        )
        
        // TODO: 일별 상세 뷰 구현 예정
      }
      .navigationTitle("캘린더")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

// MARK: - Helper Properties
private extension CalendarView {
  var periodTitle: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M.d"
    return "\(dateFormatter.string(from: currentPeriod.start)) - \(dateFormatter.string(from: currentPeriod.end))"
  }
  
  var daysInPeriod: [Date?] {
    var dates: [Date?] = []
    let calendar = Calendar.current
    
    var startOfFirstWeek = calendar.date(
      from: calendar.dateComponents(
        [.yearForWeekOfYear, .weekOfYear],
        from: currentPeriod.start
      )
    )!
    
    while startOfFirstWeek < currentPeriod.start {
      dates.append(nil)
      startOfFirstWeek = calendar.date(
        byAdding: .day,
        value: 1,
        to: startOfFirstWeek
      )!
    }
    
    var currentDate = currentPeriod.start
    while currentDate <= currentPeriod.end {
      dates.append(currentDate)
      currentDate = calendar.date(
        byAdding: .day,
        value: 1,
        to: currentDate
      )!
    }
    
    while dates.count % 7 != 0 {
      dates.append(nil)
    }
    
    return dates
  }
}

// MARK: - Calendar Header View
private struct CalendarHeaderView: View {
  let periodTitle: String
  @Binding var selectedDate: Date
  
  var body: some View {
    HStack {
      HStack {
        Button {
          // TODO: 이전 SalaryBudget으로 이동
        } label: {
          Image(systemName: "chevron.left")
        }
        
        Text(periodTitle)
          .font(.headline)
        
        Button {
          // TODO: 다음 SalaryBudget으로 이동
        } label: {
          Image(systemName: "chevron.right")
        }
      }
      
      Spacer()
      
      Button("오늘") {
        selectedDate = Date()
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
  }
}

// MARK: - Weekday Header View
private struct WeekdayHeaderView: View {
  private let weekDaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(weekDaySymbols, id: \.self) { symbol in
        Text(symbol)
          .font(.caption)
          .foregroundStyle(.gray)
          .frame(maxWidth: .infinity)
      }
    }
    .padding(.vertical, 8)
    .background(Color(uiColor: .systemGray6))
  }
}

// MARK: - Calendar Grid View
private struct CalendarGridView: View {
  let daysInPeriod: [Date?]
  let selectedDate: Date
  let onDateSelected: (Date) -> Void
  
  var body: some View {
    LazyVGrid(
      columns: Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 7
      ),
      spacing: 0
    ) {
      ForEach(
        Array(daysInPeriod.enumerated()),
        id: \.offset
      ) { _, date in
        if let validDate = date {
          let isSelected = Calendar.current.isDate(
            validDate,
            inSameDayAs: selectedDate
          )
          
          CalendarCell(
            date: validDate,
            isSelected: isSelected,
            harubee: 50000
          )
          .onTapGesture {
            onDateSelected(validDate)
          }
          
        } else {
          Color.clear
            .frame(height: 90)
        }
      }
    }
    .padding()
  }
}

// MARK: - Calendar Cell
private struct CalendarCell: View {
  let date: Date
  let isSelected: Bool
  let harubee: Int
  
  private var isToday: Bool {
    Calendar.current.isDateInToday(date)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(dayText)
        .font(.subheadline)
        .foregroundStyle(textColor)
        .padding(.top, 5)
      
      Spacer()
      
      Text(amountText)
        .font(.caption2)
        .foregroundStyle(.primary)
        .padding(.bottom, 5)
    }
    .frame(height: 90)
    .frame(maxWidth: .infinity)
    .background {
      RoundedRectangle(cornerRadius: 8)
        .fill(backgroundColor)
        .padding(1)
    }
    .padding(.vertical, 10)
  }
}

// MARK: - Calendar Cell Helper Properties
private extension CalendarCell {
  var dayText: String {
    let day = Calendar.current.component(.day, from: date)
    let month = Calendar.current.component(.month, from: date)
    return day == 1 ? "\(month)/\(day)" : "\(day)"
  }
  
  var amountText: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: "ko_KR")
    let formattedAmount = numberFormatter.string(from: NSNumber(value: harubee)) ?? "0"
    return "\(formattedAmount)"
  }
  
  var textColor: Color {
    isToday ? .white : .primary
  }
  
  var backgroundColor: Color {
    if isToday {
      return .blue
    } else if isSelected {
      return Color(uiColor: .systemGray5)
    }
    return .clear
  }
}

// MARK: - Preview
#Preview {
  NavigationView {
    CalendarView()
  }
}

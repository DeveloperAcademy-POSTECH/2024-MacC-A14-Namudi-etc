//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

// MARK: - Calendar View
struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  
  init(
    viewModel: CalendarViewModel
  ) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      Color.whiteDefault
      VStack(spacing: 0) {
        CalendarHeaderView(
          periodYearTitle: createYearTitle(
            from: viewModel.state.currentPeriod.start
          ),
          periodTitle: createPeriodTitle(
            start: viewModel.state.currentPeriod.start,
            end: viewModel.state.currentPeriod.end
          ),
          canMovePeriod: (
            previous: viewModel.state.canMovePreviousPeriod,
            next: viewModel.state.canMoveNextPeriod
          ),
          movePreviousPeriod: {
            
            viewModel.send(.movePreviousPeriod)
            
          },
          moveNextPeriod: {
            
            viewModel.send(.moveNextPeriod)
            
          }
        )
        
        ScrollView(showsIndicators: false) {
          CalendarGridView(
            daysInPeriod: createDaysInPeriod(
              start: viewModel.state.currentPeriod.start,
              end: viewModel.state.currentPeriod.end
            ),
            selectedDate: viewModel.state.selectedDate,
            dayInfos: viewModel.state.dayInfos,
            onDateSelected: { date in
              withAnimation {
                viewModel.send(.onDateSelected(date))
              }
            }
          )
          .padding(.top, 18)
          .padding(.horizontal, 14)
        }
      }
    }
    .navigationTitle("캘린더")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.send(.loadData)
    }
    .alert("오류", isPresented: .constant(viewModel.state.error != nil)) {
      Button("확인", role: .cancel) {}
    } message: {
      Text(viewModel.state.error?.localizedDescription ?? "")
    }
  }
  
  // MARK: - Helper Methods
  private func createYearTitle(from date: Date) -> String {
    date.formatted(.dateTime.year().locale(Locale(identifier: "ko_KR")))
      .replacingOccurrences(of: "년", with: "년")
  }
  
  private func createPeriodTitle(start: Date, end: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M.d"
    return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
  }
  
  private func createDaysInPeriod(start: Date, end: Date) -> [Date?] {
    let calendar = Calendar.current
    var dates: [Date?] = []
    
    let startWeekday = calendar.component(.weekday, from: start) - 1
    dates += Array(repeating: nil as Date?, count: startWeekday)
    
    var currentDate = start
    while currentDate <= end {
      dates.append(currentDate)
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    let remainingDays = (7 - (dates.count % 7)) % 7
    dates += Array(repeating: nil as Date?, count: remainingDays)
    
    return dates
  }
}

// MARK: - Calendar Header View
private struct CalendarHeaderView: View {
  private let periodYearTitle: String
  private let periodTitle: String
  private let canMovePeriod: (previous: Bool, next: Bool)
  private let movePreviousPeriod: () -> Void
  private let moveNextPeriod: () -> Void
  
  init(
    periodYearTitle: String,
    periodTitle: String,
    canMovePeriod: (previous: Bool, next: Bool),
    movePreviousPeriod: @escaping () -> Void,
    moveNextPeriod: @escaping () -> Void
  ) {
    self.periodYearTitle = periodYearTitle
    self.periodTitle = periodTitle
    self.canMovePeriod = canMovePeriod
    self.movePreviousPeriod = movePreviousPeriod
    self.moveNextPeriod = moveNextPeriod
  }
  
  var body: some View {
    VStack(spacing: 3) {
      Text(periodYearTitle)
        .font(.pretendardMedium_12)
      
      HStack(alignment: .center, spacing: 38) {
        navigationButton(
          direction: .backward,
          isEnabled: canMovePeriod.previous,
          action: movePreviousPeriod
        )
        
        Text(periodTitle)
          .font(.pretendardSemibold_24)
        
        navigationButton(
          direction: .forward,
          isEnabled: canMovePeriod.next,
          action: moveNextPeriod
        )
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 22)
    .padding(.bottom, 15)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
  }
  
  private func navigationButton(
    direction: NavigationDirection,
    isEnabled: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: direction.imageName)
        .font(.custom("SF Pro", size: 16))
        .opacity(isEnabled ? 1 : 0)
    }
    .disabled(!isEnabled)
  }
  
  private enum NavigationDirection {
    case forward, backward
    
    var imageName: String {
      switch self {
      case .forward: return "chevron.right"
      case .backward: return "chevron.left"
      }
    }
  }
}

// MARK: - Calendar Grid View
private struct CalendarGridView: View {
  private let daysInPeriod: [Date?]
  private let selectedDate: Date
  private let dayInfos: [DayInfo]
  private let onDateSelected: (Date) -> Void
  
  private var weeks: [[Date?]] {
    stride(from: 0, to: daysInPeriod.count, by: 7).map {
      Array(daysInPeriod[$0..<min($0 + 7, daysInPeriod.count)])
    }
  }
  
  init(
    daysInPeriod: [Date?],
    selectedDate: Date,
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
      
      VStack(spacing: 8) {
        ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
          VStack(spacing: 0) {
            LazyVGrid(
              columns: Array(repeating: .init(.flexible(), spacing: 0), count: 7),
              spacing: 0
            ) {
              ForEach(Array(week.enumerated()), id: \.offset) { _, date in
                if let validDate = date {
                  CalendarCell(
                    date: validDate,
                    isSelected: Calendar.current.isDate(
                      validDate,
                      inSameDayAs: selectedDate
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

// MARK: - Calendar Cell
private struct CalendarCell: View {
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
  
  private var textColor: Color {
    if isSelected || isToday {
      return .whiteDefault
    }
    return .textBlack
  }
  
  private var backgroundColor: Color {
    if isSelected {
      return .main
    }
    if isToday {
      return .mainBright
    }
    return .whiteDefault
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

// MARK: - Preview
#Preview {
  NavigationView {
    CalendarView(viewModel: DIContainer.shared.makeCalendarViewModel())
  }
}

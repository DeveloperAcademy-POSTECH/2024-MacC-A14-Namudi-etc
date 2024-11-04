//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by assistant on 11/4/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - Calendar View
struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  
  init(viewModel: CalendarViewModel) {
    _viewModel = State(initialValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      Color.whiteDefault.ignoresSafeArea()
      
      VStack(spacing: 0) {
        headerView
        calendarContent
      }
    }
    .navigationTitle("캘린더")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear { viewModel.send(.initialData) }
    .alert("오류", isPresented: .constant(viewModel.state.error != nil)) {
      Button("확인", role: .cancel) { fatalError() }
    } message: {
      Text(viewModel.state.error?.localizedDescription ?? "")
    }
  }
  
  // MARK: - Header View
  private var headerView: some View {
    VStack(spacing: 3) {
      Text(viewModel.state.currentPeriod.start.yearString)
        .font(.pretendardMedium_12)
      
      HStack(alignment: .center, spacing: 38) {
        navigationButton(direction: .previous)
        periodTitle
        navigationButton(direction: .next)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 22)
    .padding(.bottom, 15)
    .padding(.horizontal, 50)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
  }
  
  private var periodTitle: some View {
    Text(createPeriodTitle())
      .font(.pretendardSemibold_24)
      .frame(maxWidth: .infinity)
  }
  
  private func navigationButton(
    direction: CalendarPagingDirection
  ) -> some View {
    let isEnabled = direction == .next ?
    viewModel.state.canMoveNextPeriod :
    viewModel.state.canMovePreviousPeriod
    
    return Button {
      viewModel.send(direction == .next ? .moveNextPeriod : .movePreviousPeriod)
    } label: {
      Image(systemName: direction.imageName)
        .font(.custom("SF Pro", size: 16))
        .opacity(isEnabled ? 1 : 0)
    }
    .disabled(!isEnabled)
  }
  
  // MARK: - Calendar Content
  private var calendarContent: some View {
    TabView(selection: periodBinding) {
      ForEach(0..<viewModel.state.periodsCount, id: \.self) { index in
        CalendarBodyPageView(viewModel: viewModel)
          .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
  
  // MARK: - Helper Methods
  private var periodBinding: Binding<Int> {
    Binding(
      get: { viewModel.state.currentBudgetIndex },
      set: { newIndex in
        let oldIndex = viewModel.state.currentBudgetIndex
        if newIndex > oldIndex {
          if viewModel.state.canMoveNextPeriod {
            viewModel.send(.moveNextPeriod)
          }
        } else if newIndex < oldIndex {
          if viewModel.state.canMovePreviousPeriod {
            viewModel.send(.movePreviousPeriod)
          }
        }
      }
    )
  }
  
  private func createPeriodTitle() -> String {
    let period = viewModel.state.currentPeriod
    return "\(period.start.monthDayString) - \(period.end.monthDayString)"
  }
}

// MARK: - Calendar Body Page View
private struct CalendarBodyPageView: View {
  let viewModel: CalendarViewModel
  
  private var weeks: [[Date?]] {
    let dates = createDaysInPeriod()
    return stride(from: 0, to: dates.count, by: 7).map {
      Array(dates[$0..<min($0 + 7, dates.count)])
    }
  }
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(showsIndicators: false) {
        calendarGrid
          .padding(.top, 18)
          .padding(.horizontal, 14)
        
        Rectangle()
          .fill(Color.gray.opacity(0))
          .frame(height: 25)
          .frame(maxWidth: .infinity)
        
        /* CalendarDailyView()
         .id("dailyView") */
      }
    }
  }
  
  private var calendarGrid: some View {
    VStack(spacing: 0) {
      WeekdayHeaderView()
        .padding(.bottom, 8)
      
      VStack(spacing: 0) {
        ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
          WeekRowView(
            viewModel: viewModel,
            week: week,
            isLastRow: index == weeks.count - 1
          )
        }
      }
    }
  }
  
  private func createDaysInPeriod() -> [Date?] {
    let calendar = Calendar.current
    let start = viewModel.state.currentPeriod.start
    let end = viewModel.state.currentPeriod.end
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

// MARK: - Weekday Header View
private struct WeekdayHeaderView: View {
  private let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
  
  var body: some View {
    VStack {
      HStack(spacing: 0) {
        ForEach(weekDays, id: \.self) { day in
          Text(day)
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

// MARK: - Week Row View
private struct WeekRowView: View {
  let viewModel: CalendarViewModel
  let week: [Date?]
  let isLastRow: Bool
  
  var body: some View {
    VStack(spacing: 8) {
      LazyVGrid(
        columns: Array(repeating: .init(.flexible(), spacing: 0), count: 7),
        spacing: 0
      ) {
        ForEach(Array(week.enumerated()), id: \.offset) { _, date in
          if let validDate = date {
            CalendarCell(
              viewModel: viewModel,
              date: validDate
            )
            .onTapGesture {
              viewModel.send(.onDayCellSelected(validDate))
            }
          } else {
            Color.clear.frame(height: 90)
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

// MARK: - Calendar Cell
private struct CalendarCell: View {
  let viewModel: CalendarViewModel
  let date: Date
  
  private var dayInfo: CalendarDayInfo? {
    viewModel.state.dayInfos.first { $0.date.isSameDay(as: date) }
  }
  
  private var isSelected: Bool {
    date.isSameDay(as: viewModel.state.selectedDate ?? Date())
  }
  
  private var isToday: Bool {
    date.isToday
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(dayText)
        .font(.pretendardMedium_14)
        .foregroundStyle(dayTextColor)
        .padding(.top, 5)
      
      hexagonView
      
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
  
  private var hexagonView: some View {
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
  }
  
  private var dayText: String {
    date.calendarDayText
  }
  
  private var amountText: String {
    (dayInfo?.harubee ?? 0).formatted(.number)
  }
  
  private var dayTextColor: Color {
    isSelected || isToday ? .whiteDefault : .textBlack
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
    }
    return .whiteDefault
  }
  
  private var hexagonImage: ImageResource? {
    guard let info = dayInfo else { return nil }
    
    if info.isOverHarubee && info.hasExpense {
      return .hexagonBad
    } else if !info.isOverHarubee && info.hasExpense {
      return .hexagonGood
    } else if isToday {
      return .hexagonNone
    }
    return nil
  }
}

// MARK: - Calendar Paging Direction
private enum CalendarPagingDirection {
  case next, previous
  
  var imageName: String {
    switch self {
    case .next: return "chevron.right"
    case .previous: return "chevron.left"
    }
  }
}

// MARK: - Private Extension
private extension Calendar {
    static let korean: Calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar
    }()
}

private extension DateFormatter {
    static let monthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        return formatter
    }()
}

private extension Date {
    var yearString: String {
        formatted(.dateTime.year().locale(Locale(identifier: "ko_KR")))
            .replacingOccurrences(of: "년", with: "년")
    }
    
    var monthDayString: String {
        DateFormatter.monthDay.string(from: self)
    }
    
    var calendarDayText: String {
        let day = Calendar.korean.component(.day, from: self)
        let month = Calendar.korean.component(.month, from: self)
        return day == 1 ? "\(month)/\(day)" : "\(day)"
    }
    
    var isToday: Bool {
        Calendar.korean.isDateInToday(self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        Calendar.korean.isDate(self, inSameDayAs: date)
    }
}

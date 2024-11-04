//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by assistant on 11/4/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

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
    .onAppear {
      viewModel.send(.initialData)
      viewModel.send(.onDayCellSelected(Date()))
    }
    .alert("오류", isPresented: .constant(viewModel.state.error != nil)) {
      Button("확인", role: .cancel) {}
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
  
  private func navigationButton(direction: CalendarPagingDirection) -> some View {
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
        calendarGrid(proxy: proxy)
          .padding(.top, 18)
          .padding(.horizontal, 14)
        
        Rectangle()
          .fill(Color.gray.opacity(0))
          .frame(height: 25)
          .frame(maxWidth: .infinity)
        
        CalendarDailyView(viewModel: viewModel)
          .id("dailyView")
      }
    }
  }
  
  private func calendarGrid(proxy: ScrollViewProxy) -> some View {
    VStack(spacing: 0) {
      WeekdayHeaderView()
        .padding(.bottom, 8)
      
      VStack(spacing: 0) {
        ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
          WeekRowView(
            viewModel: viewModel,
            week: week,
            isLastRow: index == weeks.count - 1,
            proxy: proxy
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
    
    // Add leading empty cells
    let startWeekday = calendar.component(.weekday, from: start) - 1
    dates += Array(repeating: nil as Date?, count: startWeekday)
    
    // Add days in period
    var currentDate = start
    while currentDate <= end {
      dates.append(currentDate)
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    // Add trailing empty cells to complete the last week
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
        .frame(height: 1/UIScreen.main.scale)
    }
  }
}

// MARK: - Week Row View
private struct WeekRowView: View {
  let viewModel: CalendarViewModel
  let week: [Date?]
  let isLastRow: Bool
  let proxy: ScrollViewProxy
  
  var body: some View {
    VStack(spacing: 8) {
      LazyVGrid(
        columns: Array(repeating: .init(.flexible(), spacing: 0), count: 7),
        spacing: 0
      ) {
        ForEach(Array(week.enumerated()), id: \.offset) { index, date in
          if let validDate = date {
            CalendarCell(viewModel: viewModel, date: validDate)
              .onTapGesture {
                viewModel.send(.onDayCellSelected(validDate))
                withAnimation {
                  proxy.scrollTo("dailyView", anchor: .top)
                }
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
      
      Text(amountDisplayText)
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
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
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
  
  private var amountDisplayText: String {
    if let info = dayInfo {
      if date <= Date() && info.expense != nil {
        return (info.expense ?? 0).formatted(.number)
      }
      return info.harubee.formatted(.number)
    }
    return "0"
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
  
  private var hexagonImage: Image? {
    guard let info = dayInfo else { return nil }
    
    if info.isOverHarubee && info.hasExpense {
      return Image.hexagoneBad
    } else if !info.isOverHarubee && info.hasExpense {
      return Image.hexagoneGood
    } else if isToday {
      return Image.hexagonNone
    }
    return nil
  }
}

// MARK: - Calendar Daily View
private struct CalendarDailyView: View {
  let viewModel: CalendarViewModel
  @State private var showHarubeeAdjustSheet = false
  @State private var showTransactionInputSheet = false
  @State private var showTransactionExpenseSheet = false
  @State private var showMemoMenu = false
  @State private var showAddMemoSheet = false
  @State private var showEditMemoSheet = false
  
  private var selectedDayInfo: CalendarDayInfo? {
    guard let selectedDate = viewModel.state.selectedDate else { return nil }
    return viewModel.state.dayInfos.first { $0.date.isSameDay(as: selectedDate) }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      dailyHarubeeSection
        .padding(.horizontal, 16)
      
      transactionSection
        .padding(.top, 16)
        .padding(.horizontal, 16)
      
      memoSection
        .padding(.top, 30)
        .padding(.horizontal, 16)
      
      fixedExpenseSection
        .padding(.top, 30)
    }
    .padding(.top, 10)
    .padding(.bottom, 30)
  }
  
  // MARK: - Daily Harubee Section
  private var dailyHarubeeSection: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.mainBright, lineWidth: 1)
        .frame(height: 53)
      
      HStack {
        Text("하루비")
          .font(.pretendardSemibold_16)
          .foregroundStyle(Color.textBlack)
          .padding(.leading, 14)
        
        Spacer()
        
        Text(formatAmount(selectedDayInfo?.harubee ?? 0))
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.main)
          .padding(.trailing, 14)
      }
      .contentShape(Rectangle())
      .onTapGesture {
        showHarubeeAdjustSheet = true
      }
      .sheet(isPresented: $showHarubeeAdjustSheet) {
        HarubeeAdjustView()
          .presentationDetents([.fraction(0.75)])
      }
    }
  }
  
  // MARK: - Transaction Section
  private var transactionSection: some View {
    HStack(spacing: 9) {
      transactionCard(
        title: "수입",
        amount: selectedDayInfo?.income,
        action: { showTransactionInputSheet = true }
      )
      
      transactionCard(
        title: "지출",
        amount: selectedDayInfo?.expense,
        action: { showTransactionExpenseSheet = true }
      )
    }
    .frame(height: 84)
    .sheet(isPresented: $showTransactionInputSheet) {
      TransactionInputView(isFocusedExpense: true)
        .presentationDetents([.fraction(0.75)])
    }
    .sheet(isPresented: $showTransactionExpenseSheet) {
      TransactionInputView(isFocusedExpense: false)
        .presentationDetents([.fraction(0.75)])
    }
  }
  
  private func transactionCard(title: String, amount: Int?, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      ZStack {
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.textBrighter30)
        
        VStack(spacing: 16) {
          Text(title)
            .font(.pretendardSemibold_16)
            .foregroundStyle(Color.textBlack)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
          
          Text(formatAmount(amount ?? 0))
            .font(.pretendardSemibold_18)
            .foregroundStyle(Color.textBlack)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 14)
        }
      }
    }
  }
  
  // MARK: - Memo Section
  private var memoSection: some View {
    VStack(spacing: 8) {
      HStack {
        Text("메모")
          .font(.pretendardSemibold_16)
          .foregroundStyle(Color.textBlack)
        
        Spacer()
        
        Button(action: { showAddMemoSheet = true }) {
          Image(systemName: "plus")
            .frame(width: 19, height: 21)
            .foregroundStyle(Color.textBlack)
        }
      }
      .padding(.horizontal, 6)
      
      if selectedDayInfo?.memos.isEmpty ?? true {
        emptyMemoView
      } else {
        memoListView
      }
    }
    .sheet(isPresented: $showAddMemoSheet) {
      DailyMemoView { memo in
        if let dayInfo = selectedDayInfo {
          viewModel.send(.saveMemo(dayInfo, memo))
        }
      }
      .presentationDetents([.fraction(0.25)])
    }
  }
  
  private var emptyMemoView: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.textBrighter, lineWidth: 1)
        .frame(height: 52)
      
      Text("메모가 없습니다")
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.textBright)
    }
  }
  
  private var memoListView: some View {
    ScrollView {
      VStack(spacing: 8) {
        ForEach(selectedDayInfo?.memos ?? [], id: \.self) { memo in
          Menu {
            Button {
              showEditMemoSheet = true
            } label: {
              Label("메모 수정하기", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
              if let dayInfo = selectedDayInfo {
                viewModel.send(.deleteMemo(dayInfo, memo))
              }
            } label: {
              Label("메모 삭제하기", systemImage: "trash")
            }
          } label: {
            MemoRow(memo: memo)
          }
          .buttonStyle(.plain) // Menu 버튼 스타일 제거
          .sheet(isPresented: $showEditMemoSheet) {
            DailyMemoView(existingMemo: memo) { memo in
              if let dayInfo = selectedDayInfo {
                viewModel.send(.saveMemo(dayInfo, memo))
              }
            }
            .presentationDetents([.fraction(0.25)])
          }
        }
      }
    }
    .frame(maxHeight: 150)
  }
  
  // MARK: - Fixed Expense Section
  private var fixedExpenseSection: some View {
    VStack(spacing: 0) {
      Divider()
        .background(Color.textBlack10)
        .padding(.horizontal, 16)
      
      Text("예정된 고정 지출")
        .font(.pretendardSemibold_16)
        .foregroundStyle(Color.textBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 22)
        .padding(.top, 14)
      
      if selectedDayInfo?.todayFixedExpense.isEmpty ?? true {
        emptyFixedExpenseView
      } else {
        fixedExpenseList
      }
    }
  }
  
  private var emptyFixedExpenseView: some View {
    Text("예정된 고정 지출이 없습니다")
      .font(.pretendardMedium_14)
      .foregroundStyle(Color.textBright)
      .padding(.top, 22)
      .padding(.horizontal, 22)
  }
  
  private var fixedExpenseList: some View {
    VStack(spacing: 14) {
      ForEach(selectedDayInfo?.todayFixedExpense ?? [], id: \.id) { expense in
        HStack {
          Text(expense.name)
            .font(.pretendardMedium_14)
            .foregroundStyle(Color.textBlack)
          
          Spacer()
          
          Text(formatAmount(expense.price))
            .font(.pretendardSemibold_14)
            .foregroundStyle(Color.redDefault)
        }
        .padding(.horizontal, 22)
      }
    }
    .padding(.top, 22)
  }
  
  private func formatAmount(_ amount: Int) -> String {
    return "\(amount.formatted(.number))원"
  }
}

// MARK: - Memo Row
private struct MemoRow: View {
  let memo: String
  
  var body: some View {
    HStack {
      Text(memo)
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.textBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    .background(
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.textBrighter, lineWidth: 1)
    )
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

extension Date {
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

#Preview {
  CalendarView(viewModel: DIContainer.shared.makeCalendarViewModel())
}

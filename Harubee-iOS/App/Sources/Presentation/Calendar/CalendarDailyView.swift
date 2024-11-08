//
//  CalendarDailyView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Domain

struct CalendarDailyView: View {
  // MARK: - Properties
  let viewModel: CalendarViewModel
  
  @State private var dailyBudget: DailyBudget
  @State private var selectedDate: Date
  @State private var activeSheet: SheetType?
  
  init(viewModel: CalendarViewModel, dailyBudget: DailyBudget) {
    self.viewModel = viewModel
    _dailyBudget = State(initialValue: dailyBudget)
    _selectedDate = State(initialValue: dailyBudget.date)
  }
  
  // MARK: - Sheet Types
  private enum SheetType: Identifiable {
    case harubeeAdjust
    case transactionIncome
    case transactionExpense
    case addMemo
    case editMemo(String)
    
    var id: String {
      switch self {
      case .harubeeAdjust: return "harubeeAdjust"
      case .transactionIncome: return "transactionInput"
      case .transactionExpense: return "transactionExpense"
      case .addMemo: return "addMemo"
      case .editMemo: return "editMemo"
      }
    }
  }
  
  // MARK: - Body
  var body: some View {
    ZStack {
      VStack {
        WeeklyCalendarView(
          viewModel: viewModel,
          selectedDate: selectedDate,
          onCellSelect: { date in
            selectedDate = date
            if let newDailyBudget = viewModel.state.currentBudget?.dailyBudgets.first(where: {
              $0.date.isSameDay(as: date)
            }) {
              dailyBudget = newDailyBudget
            }
          }
        )
        
        ScrollView {
          VStack(spacing: 0) {
            HarubeeSectionView(
              harubee: dailyBudget.harubee ?? Int(viewModel.state.currentBudget!.defaultHarubee),
              onTap: { activeSheet = .harubeeAdjust }
            )
            .padding(.horizontal, 16)
            .disabled(!dailyBudget.date.isSameDay(as: Date()))
            
            TransactionSectionView(
              income: dailyBudget.income,
              expense: dailyBudget.expense,
              harubee: dailyBudget.harubee ?? Int(viewModel.state.currentBudget!.defaultHarubee),
              onIncomeEdit: { activeSheet = .transactionIncome },
              onExpenseEdit: { activeSheet = .transactionExpense }
            )
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            divider
              .padding(.top, 26)
            
            MemoSectionView(
              memos: dailyBudget.memo,
              onAdd: handleMemoAdd,
              onEdit: handleMemoEdit,
              onDelete: handleMemoDelete
            )
            .padding(.top, 20)
            .padding(.horizontal, 22)
            
            if let budget = viewModel.state.currentBudget,
               let fixedExpenses = getFixedExpenses(for: dailyBudget.date, from: budget),
               !fixedExpenses.isEmpty {
              divider
                .padding(.top, 20)
              
              FixedExpenseSectionView(expenses: fixedExpenses)
                .padding(.horizontal, 22)
            }
          }
          .padding(.top, 20)
        }
        .sheet(item: $activeSheet) { type in
          sheetContent(for: type)
        }
      }
      if !selectedDate.isToday && viewModel.isCurrentPeriodContainsToday {
        moveToTodayButton
      }
    }
    .navigationBarStyle(.main(title: "일별 보기", backTitle: "뒤로"))
    // TODO: - 도움말 모디파이어 기능 구현
    .toolbar {
      Image(systemName: "questionmark.circle")
        .foregroundStyle(Color.whiteDefault)
        .tapFeedback {
          
        }
    }
  }
  
  // MARK: - Helper Views
  private var divider: some View {
    Rectangle()
      .fill(Color.textBlack5)
      .frame(height: 6)
      .frame(maxWidth: .infinity)
  }
  
  private var moveToTodayButton: some View {
    VStack(spacing: 0) {
      Spacer()
      Button {
        HapticManager.shared.trigger(.tap)
        withAnimation {
          let today = Date()
          selectedDate = today
          if let todayBudget = viewModel.state.currentBudget?.dailyBudgets.first(where: {
            $0.date.isSameDay(as: today)
          }) {
            dailyBudget = todayBudget
          }
        }
      } label: {
        HStack(spacing: 4) {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: 14))
          Text("오늘로 돌아가기")
            .font(.pretendardMedium_14)
        }
        .foregroundColor(.whiteDefault)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
          Capsule()
            .fill(Color.mainBright)
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        )
      }
      .padding(.bottom, 14)
    }
  }
  
  // MARK: - Helper Methods
  private func getFixedExpenses(for date: Date, from budget: SalaryBudget) -> [TransactionItem]? {
    budget.fixedExpenses.filter {
      Calendar.current.isDate($0.date, equalTo: date, toGranularity: .day)
    }
  }
  
  private func handleMemoAdd(_ memo: String) {
    viewModel.send(.addMemo(dailyBudget, memo))
  }
  
  private func handleMemoEdit(oldMemo: String, newMemo: String) {
    viewModel.send(.addMemo(dailyBudget, newMemo))
  }
  
  private func handleMemoDelete(_ memo: String) {
    viewModel.send(.deleteMemo(dailyBudget, memo))
  }
  
  @ViewBuilder
  private func sheetContent(for type: SheetType) -> some View {
    switch type {
    case .harubeeAdjust:
      HarubeeAdjustView()
        .presentationDetents([.fraction(0.75)])
      
    case .transactionIncome:
      TransactionInputView(isFocusedExpense: false)
        .presentationDetents([.fraction(0.75)])
      
    case .transactionExpense:
      TransactionInputView(isFocusedExpense: true)
        .presentationDetents([.fraction(0.75)])
      
    case .addMemo:
      DailyMemoView { memo in
        handleMemoAdd(memo)
      }
      .presentationDetents([.fraction(0.25)])
      
    case .editMemo(let oldMemo):
      DailyMemoView(existingMemo: oldMemo) { newMemo in
        handleMemoEdit(oldMemo: oldMemo, newMemo: newMemo)
      }
      .presentationDetents([.fraction(0.25)])
    }
  }
}

// MARK: - Weekly Calendar View
struct WeeklyCalendarView: View {
  let viewModel: CalendarViewModel
  let selectedDate: Date
  let onCellSelect: (Date) -> Void
  
  private let daysInWeek = 7
  
  private var weeks: [[Date]] {
    guard let budget = viewModel.state.currentBudget else { return [] }
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: budget.startDate, to: budget.endDate)
    let days = components.day ?? 0
    
    let allDates = (0...days).compactMap { offset in
      calendar.date(byAdding: .day, value: offset, to: budget.startDate)
    }
    
    return allDates.chunked(into: daysInWeek)
  }
  
  var body: some View {
    GeometryReader { geometry in
      let availableWidth = geometry.size.width
      let cellWidth = (availableWidth - (CGFloat(daysInWeek - 1) * 8) - 32) / CGFloat(daysInWeek)
      
      ScrollView(.horizontal, showsIndicators: false) {
        ScrollViewReader { proxy in
          LazyHStack(spacing: 0) {
            ForEach(weeks.indices, id: \.self) { weekIndex in
              WeekView(
                dates: weeks[weekIndex],
                selectedDate: selectedDate,
                onDateSelect: onCellSelect,
                isLastWeek: weekIndex == weeks.count - 1,
                weekCount: weeks[weekIndex].count,
                containerWidth: availableWidth,
                cellWidth: cellWidth
              )
              .id(weekIndex)
            }
          }
          .scrollTargetLayout()
          .onAppear {
            scrollToCurrentWeek(proxy)
          }
          .onChange(of: selectedDate) { _, newDate in
            scrollToWeek(for: newDate, proxy: proxy)
          }
        }
      }
      .scrollTargetBehavior(.paging)
    }
    .frame(height: 82)
    .background(Color.main)
  }
  
  private func scrollToCurrentWeek(_ proxy: ScrollViewProxy) {
    if let weekIndex = weeks.firstIndex(where: { week in
      week.contains { Calendar.current.isDate($0, equalTo: selectedDate, toGranularity: .day) }
    }) {
      proxy.scrollTo(weekIndex, anchor: .center)
    }
  }
  
  private func scrollToWeek(for date: Date, proxy: ScrollViewProxy) {
    if let weekIndex = weeks.firstIndex(where: { week in
      week.contains { Calendar.current.isDate($0, equalTo: date, toGranularity: .day) }
    }) {
      withAnimation(.smooth) {
        proxy.scrollTo(weekIndex, anchor: .center)
      }
    }
  }
}

private extension Array {
  func chunked(into size: Int) -> [[Element]] {
    stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }
}

// MARK: - Week View
private struct WeekView: View {
  let dates: [Date]
  let selectedDate: Date
  let onDateSelect: (Date) -> Void
  let isLastWeek: Bool
  let weekCount: Int
  let containerWidth: CGFloat
  let cellWidth: CGFloat
  
  var body: some View {
    GeometryReader { geometry in
      LazyHStack(spacing: 8) {
        ForEach(dates, id: \.timeIntervalSince1970) { date in
          WeeklyDayCell(
            date: date,
            isSelected: Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .day),
            isToday: date.isToday,
            cellWidth: cellWidth
          )
          .onTapGesture {
            HapticManager.shared.trigger(.tap)
            withAnimation(.spring(duration: 0.2)) {
              onDateSelect(date)
            }
          }
        }
      }
      .padding(.horizontal, 16)
      .frame(
        width: geometry.size.width,
        alignment: isLastWeek && weekCount < 7 ? .leading : .center
      )
      .frame(maxHeight: .infinity)
      .contentShape(Rectangle())
    }
    .frame(width: containerWidth)
  }
}

// MARK: - Weekly Day Cell
private struct WeeklyDayCell: View {
  let date: Date
  let isSelected: Bool
  let isToday: Bool
  let cellWidth: CGFloat
  
  private var weekday: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "E"
    return formatter.string(from: date)
  }
  
  private var day: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter.string(from: date)
  }
  
  var body: some View {
    VStack(spacing: 9) {
      Text(weekday)
        .font(.pretendardMedium_14)
        .foregroundStyle(Color.whiteDefault)
      
      ZStack {
        if isSelected {
          Circle()
            .fill(Color.whiteDefault)
            .frame(width: min(30, cellWidth * 0.7), height: min(30, cellWidth * 0.7))
        } else if isToday {
          Circle()
            .stroke(Color.whiteDefault, lineWidth: 1)
            .frame(width: min(30, cellWidth * 0.7), height: min(30, cellWidth * 0.7))
        }
        
        Text(day)
          .font(.pretendardSemibold_16)
          .foregroundStyle(isSelected ? Color.main : .whiteDefault)
      }
      .frame(width: min(30, cellWidth * 0.7), height: min(30, cellWidth * 0.7))
    }
    .frame(width: cellWidth)
    .frame(height: 64)
  }
}


// MARK: - Harubee Section View
struct HarubeeSectionView: View {
  let harubee: Int
  let onTap: () -> Void
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.mainBright, lineWidth: 1)
        .frame(height: 53)
      
      HStack {
        Text("하루비")
          .font(.pretendardSemibold_16)
          .foregroundStyle(Color.textBlack)
        
        Spacer()
        
        Text("\(harubee.formatted(.number))원")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.main)
      }
      .padding(.horizontal, 14)
    }
    .tapFeedback(haptic: .none) {
      onTap()
    }
  }
}

// MARK: - Transaction Section View
struct TransactionSectionView: View {
  let income: Int?
  let expense: Int?
  let harubee: Int
  let onIncomeEdit: () -> Void
  let onExpenseEdit: () -> Void
  
  private var isOverHarubee: Bool {
    guard let expense = expense else { return false }
    return expense > harubee
  }
  
  var body: some View {
    VStack(spacing: 6) {
      HStack(spacing: 9) {
        TransactionCard(
          title: "수입",
          amount: income,
          style: .constant,
          action: onIncomeEdit
        )
        
        TransactionCard(
          title: "지출",
          amount: expense,
          style: expense == nil ? .constant : (isOverHarubee ? .warning : .saving),
          action: onExpenseEdit
        )
      }
      .frame(height: 84)
      
      if let expense = expense {
        comparisonLabel(expense: expense)
      }
    }
  }
  
  private func comparisonLabel(expense: Int) -> some View {
    HStack(alignment: .center, spacing: 2) {
      Spacer()
      Text("하루비보다")
      comparisonIcon
      differenceAmount(expense: expense)
        .padding(.leading, -3)
      Text(isOverHarubee ? " 더 썼어요" : " 덜 썼어요")
    }
    .font(.pretendardMedium_14)
  }
  
  private var comparisonIcon: some View {
    Image(systemName: isOverHarubee ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
      .font(.custom("SF Pro", size: 10))
      .foregroundColor(isOverHarubee ? .red : .main)
      .padding(.trailing, -1)
  }
  
  private func differenceAmount(expense: Int) -> some View {
    Text(" \(abs(harubee - expense))원")
      .font(.pretendardSemibold_14)
      .foregroundColor(isOverHarubee ? .red : .main)
  }
}
private struct TransactionCard: View {
  let title: String
  let amount: Int?
  let style: Style
  let action: () -> Void
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .fill(style.backgroundColor)
      
      VStack(spacing: 16) {
        Text(title)
          .font(.pretendardSemibold_16)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text("\(amount?.formatted(.number) ?? "- ")원")
          .font(.pretendardSemibold_18)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .foregroundStyle(style.textColor)
      .padding(.horizontal, 14)
    }
    .tapFeedback(haptic: .none) {
      action()
    }
  }
  
  enum Style {
    case constant, warning, saving
    
    var backgroundColor: Color {
      switch self {
      case .constant: return .textBrighter30
      case .warning: return .red10
      case .saving: return .mainBrighter60
      }
    }
    
    var textColor: Color {
      switch self {
      case .constant: return .textBlack
      case .warning: return .redDefault
      case .saving: return .main
      }
    }
  }
}

// MARK: - Memo Section View
struct MemoSectionView: View {
  let memos: [String]
  let onAdd: (String) -> Void
  let onEdit: (String, String) -> Void
  let onDelete: (String) -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 0) {
        Text("메모")
          .font(.pretendardSemibold_16)
        Spacer()
        Image(systemName: "plus")
          .frame(width: 44, height: 21)
          .tapFeedback(haptic: .none) {
            onAdd("")
          }
      }
      .foregroundStyle(Color.textBlack)
      
      if memos.isEmpty {
        Text("입력된 메모가 없어요")
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.textBright)
          .padding(.vertical, 8)
      } else {
        List {
          ForEach(memos, id: \.self) { memo in
            Text(memo)
              .font(.pretendardMedium_16)
              .foregroundStyle(Color.textBlack)
              .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  onDelete(memo)
                } label: {
                  Text("삭제")
                    .font(.pretendardMedium_14)
                }
                
                Button {
                  onEdit(memo, memo)
                } label: {
                  Text("수정")
                    .font(.pretendardMedium_14)
                }
              }
              .tapFeedback(haptic: .none) {
                onEdit(memo, memo)
              }
          }
        }
        .listStyle(.plain)
        .frame(height: min(CGFloat(memos.count) * 44, 200))
      }
    }
  }
}

// MARK: - Fixed Expense Section View
struct FixedExpenseSectionView: View {
  let expenses: [TransactionItem]
  
  var body: some View {
    VStack(spacing: 26) {
      Text("예정된 고정 지출")
        .font(.pretendardSemibold_16)
        .foregroundStyle(Color.textBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
      
      expenseList
    }
  }
  
  private var expenseList: some View {
    VStack(spacing: 14) {
      ForEach(expenses) { expense in
        HStack {
          Text(expense.name)
            .font(.pretendardMedium_16)
            .foregroundStyle(Color.textBlack)
          
          Spacer()
          
          Text("\(expense.price.formatted(.number))원")
            .font(.pretendardSemibold_16)
            .foregroundStyle(Color.redDefault)
        }
      }
    }
  }
}

// MARK: - Preview
#Preview {
  NavigationStack {
    CalendarView(viewModel: DIContainer.shared.makeCalendarViewModel())
  }
}

#Preview {
  CalendarDailyView(
    viewModel: DIContainer.shared.makeCalendarViewModel(),
    dailyBudget: DailyBudget(
      date: Date(),
      harubee: 50000,
      memo: ["테스트 메모"],
      expense: nil,
      income: nil
    )
  )
}

#Preview {
  CalendarDailyView(
    viewModel: DIContainer.shared.makeCalendarViewModel(),
    dailyBudget: DailyBudget(
      date: Date(),
      harubee: 50000,
      memo: ["테스트 메모"],
      expense: 55000,
      income: 12000
    )
  )
}

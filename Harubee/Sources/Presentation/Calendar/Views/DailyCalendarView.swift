//
//  CalendarDailyView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - DailyCalendarView
struct DailyCalendarView: View {
  @Environment(MainCoordinator.self) private var coordinator
  let viewModel: CalendarViewModel
  let initialDate: Date
  
  @State private var activeSheet: SheetType?
  @State private var infoBubbleVisible: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      WeeklyCalendar(
        selectedDate: viewModel.state.selectedDate ?? initialDate,
        budget: viewModel.state.currentBudget!,
        onSelect: { date in viewModel.send(.selectDate(date)) }
      )
      .frame(height: 98)
      .background(Color.main)
      
      if let budget = viewModel.selectedDailyBudget,
         let currentBudget = viewModel.state.currentBudget {
        ScrollView {
          VStack(spacing: 20) {
            HarubeeSection(
              budget: budget,
              defaultHarubee: Int(currentBudget.defaultHarubee)
            ) {
              activeSheet = .harubeeAdjust
            }
            .zIndex(2)
            .harubeeInfoBubble($infoBubbleVisible)
            
            TransactionSection(
              budget: budget,
              defaultHarubee: Int(currentBudget.defaultHarubee),
              infoBubbleVisible: $infoBubbleVisible,
              onIncomeEdit: { activeSheet = .transactionIncome },
              onExpenseEdit: { activeSheet = .transactionExpense }
            )
            .zIndex(1)
            
            MemoSection(
              memos: budget.memo,
              infoBubbleVisible: $infoBubbleVisible,
              onAdd: { activeSheet = .addMemo },
              onEdit: { activeSheet = .editMemo($0) },
              onDelete: { viewModel.send(.deleteMemo($0)) }
            )
            
            let fixedExpenses = currentBudget.fixedExpenses.filter {
              return $0.date.isSameDay(as: budget.date)
            }
            if !fixedExpenses.isEmpty {
              FixedExpenseSection(expenses: fixedExpenses)
            }
          }
          .padding(.top, 20)
        }
      }
    }
    .overlay {
      if infoBubbleVisible {
        Color.clear
          .contentShape(Rectangle())
          .ignoresSafeArea()
          .onTapGesture {
            infoBubbleVisible = false
          }
      }
    }
    .overlay(alignment: .bottom) {
      if !(viewModel.state.selectedDate ?? initialDate).isToday &&
          viewModel.isCurrentPeriodContainsToday {
        CalendarBottomFAB(
          title: "오늘로 돌아가기",
          titleColor: .whiteDefault,
          backgroundColor: .mainBright,
          icon: Image(systemName: "arrow.clockwise")) {
          viewModel.send(.selectDate(Date()))
        }
      }
    }
    .onChange(of: activeSheet) { _, _ in
      switch activeSheet {
      case .harubeeAdjust:
        coordinator.presentHarubeeAdjustSheet(
          salaryBudget: viewModel.state.currentBudget!,
          dailyBudget: viewModel.selectedDailyBudget!,
          completion: { viewModel.send(.updateCurrentData) }
        )
      case .transactionIncome:
        coordinator.presentTransactionInputSheet(
          salaryBudget: viewModel.state.currentBudget!,
          dailyBudget: viewModel.selectedDailyBudget!,
          focus: .income,
          completion: { viewModel.send(.updateCurrentData) }
        )
      case .transactionExpense:
        coordinator.presentTransactionInputSheet(
          salaryBudget: viewModel.state.currentBudget!,
          dailyBudget: viewModel.selectedDailyBudget!,
          focus: .expense,
          completion: { viewModel.send(.updateCurrentData) }
        )
      case .addMemo:
        coordinator.presentDailyMemoSheet { memo in
          viewModel.send(.updateMemo(.init(oldMemo: nil, newMemo: memo)))
        }
      case .editMemo(let oldMemo):
        coordinator.presentDailyMemoSheet(memo: oldMemo) { memo in
          viewModel.send(.updateMemo(
            .init(oldMemo: oldMemo, newMemo: memo))
          )
        }
      case nil:
        break
      }
      
      activeSheet = nil
    }
    .applyNavigationBarStyle(infoBubbleVisible: $infoBubbleVisible)
  }
}

private enum SheetType: Identifiable, Equatable {
  case harubeeAdjust
  case transactionIncome
  case transactionExpense
  case addMemo
  case editMemo(String)
  
  var id: String { String(describing: self) }
}

// MARK: - HarubeeSection
private struct HarubeeSection: View {
  let budget: DailyBudget
  let defaultHarubee: Int
  let onEdit: () -> Void
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .stroke(
          budget.date >= Date().formattedDate ? Color.mainBright : Color.textBrighter,
          lineWidth: 1
        )
        .frame(height: 53)
      
      HStack(spacing: 0) {
        Text(budget.date.isToday ? "오늘의 하루비" : "이 날의 하루비")
          .font(.pretendardSemibold_16)
          .foregroundStyle(Color.textBlack)
        
        Spacer()
        
        Text("\(budget.harubee ?? defaultHarubee)원")
          .font(.pretendardSemibold_18)
          .foregroundStyle(
            budget.date >= Date().formattedDate
            ? Color.main
            : Color.textBlack
          )
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.trailing, 3)
        
        if budget.date >= Date().formattedDate {
          Image(systemName: "pencil")
            .font(.custom("SF Pro", size: 16))
            .foregroundStyle(Color.mainBright)
        }
      }
      .padding(.horizontal, 14)
    }
    .tapFeedback {
      onEdit()
    }
    .disabled(budget.date < Date().formattedDate)
    .padding(.horizontal, 16)
  }
}

// MARK: - TransactionSection
private struct TransactionSection: View {
  let budget: DailyBudget
  let defaultHarubee: Int
  @Binding var infoBubbleVisible: Bool
  let onIncomeEdit: () -> Void
  let onExpenseEdit: () -> Void
  
  var body: some View {
    if budget.date <= Date().formattedDate {
      VStack(spacing: 0) {
        HStack(spacing: 9) {
          TransactionCard(
            title: "수입",
            amount: budget.income,
            style: .constant,
            action: onIncomeEdit
          )
          
          TransactionCard(
            title: "지출",
            amount: budget.expense,
            style: transactionStyle,
            action: onExpenseEdit
          )
        }
        .frame(height: 84)
        
        if let expense = budget.expense {
          ComparisonLabel(
            expense: expense,
            harubee: budget.harubee ?? defaultHarubee
          )
          .padding(.top, 6)
        }
      }
      .padding(.horizontal, 16)
      .transactionInfoBubble($infoBubbleVisible)
    }
  }
  
  private var transactionStyle: TransactionStyle {
    guard let expense = budget.expense else { return .constant }
    return expense > (budget.harubee ?? defaultHarubee)
    ? .warning
    : .saving
  }
}

private struct TransactionCard: View {
  let title: String
  let amount: Int?
  let style: TransactionStyle
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
      .padding(.horizontal, 14)
      .foregroundStyle(style.textColor)
    }
    .tapFeedback {
      action()
    }
  }
}

private enum TransactionStyle {
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

private struct ComparisonLabel: View {
  let expense: Int
  let harubee: Int
  
  var body: some View {
    HStack(alignment: .center, spacing: 2) {
      Spacer()
      Text("하루비보다")
        .font(.pretendardMedium_14)
      
      Image(
        systemName: isOverBudget 
        ? "arrowtriangle.up.fill"
        : "arrowtriangle.down.fill"
      )
        .font(.custom("SF Pro", size: 10))
        .foregroundStyle(isOverBudget ? Color.redDefault : Color.main)
        .padding(.trailing, -4)
      
      Text(" \(abs(harubee - expense))원")
        .font(.pretendardSemibold_14)
        .foregroundStyle(isOverBudget ? Color.redDefault : Color.main)
      
      Text(isOverBudget ? "더 썼어요" : "덜 썼어요")
    }
    .font(.pretendardMedium_14)
  }
  
  private var isOverBudget: Bool {
    expense > harubee
  }
}

// MARK: - MemoSection
private struct MemoSection: View {
  let memos: [String]
  @Binding var infoBubbleVisible: Bool
  let onAdd: () -> Void
  let onEdit: (String) -> Void
  let onDelete: (String) -> Void
  
  var body: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(Color.textBlack5)
        .frame(height: 6)
      
      VStack(alignment: .leading, spacing: 16) {
        HStack {
          Text("메모")
            .font(.pretendardSemibold_16)
          
          Spacer()
          
          HStack {
            Image(systemName: "plus")
              .frame(width: 30)
              .memoInfoBubble($infoBubbleVisible)
          }
          .frame(width: 44, height: 21)
          .tapFeedback {
            onAdd()
          }
        }
        .zIndex(1)
        .foregroundStyle(Color.textBlack)
        
        Group {
          if memos.isEmpty {
            Text("입력된 메모가 없어요")
              .font(.pretendardMedium_16)
              .foregroundStyle(Color.textBlack30)
              .padding(.vertical, 8)
          } else {
            MemoList(
              memos: memos,
              onEdit: onEdit,
              onDelete: onDelete
            )
          }
        }
      }
      .padding(.top, 20)
      .padding(.horizontal, 22)
    }
  }
}

private struct MemoList: View {
  let memos: [String]
  let onEdit: (String) -> Void
  let onDelete: (String) -> Void
  
  var body: some View {
    List {
      ForEach(memos, id: \.self) { memo in
        Text(memo)
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.textBlack)
          .listRowInsets(
            EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
          )
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
              onDelete(memo)
            } label: {
              Text("삭제")
                .font(.pretendardMedium_14)
            }
            
            Button {
              onEdit(memo)
            } label: {
              Text("수정")
                .font(.pretendardMedium_14)
            }
          }
          .tapFeedback {
            onEdit(memo)
          }
      }
    }
    .listStyle(.plain)
    .frame(height: min(CGFloat(memos.count) * 44, 200))
  }
}

// MARK: - FixedExpenseSection
private struct FixedExpenseSection: View {
  let expenses: [TransactionItem]
  
  var body: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(Color.textBlack5)
        .frame(height: 6)
        .padding(.top, 20)
      
      VStack(spacing: 26) {
        Text("예정된 고정 지출")
          .font(.pretendardSemibold_16)
          .foregroundStyle(Color.textBlack)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 20)
        
        VStack(spacing: 14) {
          ForEach(expenses) { expense in
            HStack {
              Text(expense.name)
                .font(.pretendardMedium_16)
                .foregroundStyle(Color.textBlack)
              
              Text("\(expense.price.formatted(.number))원")
                .font(.pretendardSemibold_18)
                .foregroundStyle(Color.redDefault)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
          }
        }
      }
      .padding(.horizontal, 22)
    }
  }
}

// MARK: - View Modifiers
private extension View {
  func applyNavigationBarStyle(
    infoBubbleVisible: Binding<Bool>
  ) -> some View {
    self.navigationBarStyle(.main(title: "", backTitle: "뒤로"))
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          HelpButton(
            infoBubbleVisible: infoBubbleVisible,
            buttonColor: .whiteDefault
          )
        }
      }
  }
  
  func errorAlert(error: Error?) -> some View {
    alert("오류", isPresented: .constant(error != nil)) {
      Button("확인", role: .cancel) {}
    } message: {
      if let error = error {
        Text(error.localizedDescription)
      }
    }
  }
}

// MARK: - InfoBubbles Modifiers
private extension View {
  func harubeeInfoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .infoBubble(isVisible: isVisible, alignment: .bottom) {
        Text("오늘과 미래의 하루비를 확인하고 조정할 수 있어요")
          .font(.pretendardMedium_12)
          .foregroundStyle(Color.textBlack)
      }
  }
  
  func transactionInfoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .background(
        Color.clear
          .infoBubble(isVisible: isVisible, alignment: .bottom) {
            Text("실제 수입과 지출을 입력할 수 있어요")
              .font(.pretendardMedium_12)
              .foregroundStyle(Color.textBlack)
          })
  }
  
  func memoInfoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .infoBubble(isVisible: isVisible, alignment: .bottomTrailing) {
        Text("하루비 조정 이유, 이 날의 일정, 지출 일기 등\n자유롭게 메모를 작성할 수 있어요")
          .font(.pretendardMedium_12)
          .foregroundStyle(Color.textBlack)
      }
  }
}

//
//  CalendarDailyView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Domain

// MARK: - DailyCalendarView
struct DailyCalendarView: View {
  let viewModel: CalendarViewModel
  let initialDate: Date
  
  @State private var activeSheet: SheetType?
  
  var body: some View {
    VStack(spacing: 0) {
      WeeklyCalendar(
        selectedDate: viewModel.state.selectedDate ?? initialDate,
        budget: viewModel.state.currentBudget!,
        onSelect: { date in viewModel.send(.selectDate(date)) }
      )
      .frame(height: 82)
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
            
            TransactionSection(
              budget: budget,
              defaultHarubee: Int(currentBudget.defaultHarubee),
              onIncomeEdit: { activeSheet = .transactionIncome },
              onExpenseEdit: { activeSheet = .transactionExpense }
            )
            
            MemoSection(
              memos: budget.memo,
              onAdd: { activeSheet = .addMemo },
              onEdit: { activeSheet = .editMemo($0) },
              onDelete: { viewModel.send(.deleteMemo($0)) }
            )
            
            let fixedExpenses = currentBudget.fixedExpenses.filter {
              Calendar.current.isDate($0.date, equalTo: budget.date, toGranularity: .day)
            }
            if !fixedExpenses.isEmpty {
              FixedExpenseSection(expenses: fixedExpenses)
            }
          }
          .padding(.top, 20)
        }
      }
    }
    .overlay(alignment: .bottom) {
      if !(viewModel.state.selectedDate ?? initialDate).isToday &&
          viewModel.isCurrentPeriodContainsToday {
        ReturnToTodayButton(title: "오늘로 돌아가기") {
          viewModel.send(.selectDate(Date()))
        }
      }
    }
    .sheet(item: $activeSheet) { type in
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
          viewModel.send(.updateMemo(.init(oldMemo: nil, newMemo: memo)))
          activeSheet = nil
        }
        .presentationDetents([.fraction(0.25)])
      case .editMemo(let oldMemo):
        DailyMemoView(existingMemo: oldMemo) { newMemo in
          viewModel.send(.updateMemo(.init(oldMemo: oldMemo, newMemo: newMemo)))
          activeSheet = nil
        }
        .presentationDetents([.fraction(0.25)])
      }
    }
    .navigationBarStyle(.main(title: "일별 보기", backTitle: "뒤로"))
  }
}

private enum SheetType: Identifiable {
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
        .stroke(Color.mainBright, lineWidth: 1)
        .frame(height: 53)
      
      HStack {
        Text("하루비")
          .font(.pretendardSemibold_16)
          .foregroundStyle(Color.textBlack)
        
        Text("\(budget.harubee ?? defaultHarubee)원")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.main)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding(.horizontal, 14)
    }
    .tapFeedback {
      onEdit()
    }
    .disabled(!budget.date.isToday)
    .padding(.horizontal, 16)
  }
}

// MARK: - TransactionSection
private struct TransactionSection: View {
  let budget: DailyBudget
  let defaultHarubee: Int
  let onIncomeEdit: () -> Void
  let onExpenseEdit: () -> Void
  
  var body: some View {
    VStack(spacing: 6) {
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
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
  }
  
  private var transactionStyle: TransactionStyle {
    guard let expense = budget.expense else { return .constant }
    return expense > (budget.harubee ?? defaultHarubee) ? .warning : .saving
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
      
      Image(systemName: isOverBudget ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        .font(.custom("SF Pro", size: 10))
        .foregroundStyle(isOverBudget ? Color.redDefault : Color.main)
        .padding(.trailing, -1)
      
      Text(" \(abs(harubee - expense))원")
        .font(.pretendardSemibold_14)
        .foregroundStyle(isOverBudget ? Color.redDefault : Color.main)
      
      Text(isOverBudget ? " 더 썼어요" : " 덜 썼어요")
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
  let onAdd: () -> Void
  let onEdit: (String) -> Void
  let onDelete: (String) -> Void
  
  var body: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(Color.textBlack5)
        .frame(height: 6)
        .padding(.top, 26)
      
      VStack(alignment: .leading, spacing: 16) {
        HStack {
          Text("메모")
            .font(.pretendardSemibold_16)
          
          Spacer()
          
          Image(systemName: "plus")
            .frame(width: 44, height: 21)
            .tapFeedback {
              onAdd()
            }
        }
        .foregroundStyle(Color.textBlack)
        
        Group {
          if memos.isEmpty {
            Text("입력된 메모가 없어요")
              .font(.pretendardMedium_16)
              .foregroundStyle(Color.textBright)
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
          .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
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

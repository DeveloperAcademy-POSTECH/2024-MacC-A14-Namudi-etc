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
  let dailyBudget: DailyBudget
  
  @State private var activeSheet: SheetType?
  
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
    ScrollView {
      VStack(spacing: 0) {
        HarubeeSectionView(
          harubee: dailyBudget.harubee ?? 0,
          onTap: { activeSheet = .harubeeAdjust }
        )
        .padding(.horizontal, 16)
        
        TransactionSectionView(
          income: dailyBudget.income,
          expense: dailyBudget.expense,
          harubee: dailyBudget.harubee ?? 0,
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
      .padding(.top, 40)
    }
    .sheet(item: $activeSheet) { type in
      sheetContent(for: type)
    }
  }
  
  // MARK: - Helper Views
  private var divider: some View {
    Rectangle()
      .fill(Color.textBlack5)
      .frame(height: 6)
      .frame(maxWidth: .infinity)
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

// MARK: - Harubee Section View
struct HarubeeSectionView: View {
  let harubee: Int
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
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
          amount: income ?? 0,
          style: .constant,
          action: onIncomeEdit
        )
        
        TransactionCard(
          title: "지출",
          amount: expense ?? 0,
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
    HStack(spacing: 0) {
      Spacer()
      Text("하루비보다")
      Text(" ")
      Image(systemName: isOverHarubee ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        .font(.custom("SF Pro", size: 12))
      Text(" \(abs(harubee - expense))원")
        .font(.pretendardSemibold_14)
      Text(isOverHarubee ? " 더 썼어요." : " 덜 썼어요.")
    }
    .font(.pretendardMedium_14)
    .foregroundColor(isOverHarubee ? .red : .main)
  }
}

private struct TransactionCard: View {
  let title: String
  let amount: Int
  let style: Style
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      ZStack {
        RoundedRectangle(cornerRadius: 5)
          .fill(style.backgroundColor)
        
        VStack(spacing: 16) {
          Text(title)
            .font(.pretendardSemibold_16)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text("\(amount.formatted(.number))원")
            .font(.pretendardSemibold_18)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .foregroundStyle(style.textColor)
        .padding(.horizontal, 14)
      }
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
  // MARK: - Properties
  let memos: [String]
  let onAdd: (String) -> Void
  let onEdit: (String, String) -> Void
  let onDelete: (String) -> Void
  
  // MARK: - Body
  var body: some View {
    VStack(spacing: 11) {
      header
      
      if memos.isEmpty {
        emptyStateView
      } else {
        memoList
      }
    }
  }
  
  // MARK: - Subviews
  private var header: some View {
    HStack {
      Text("메모")
        .font(.pretendardSemibold_16)
        .foregroundStyle(Color.textBlack)
      
      Spacer()
      
      Button {
        onAdd("")
      } label: {
        Image(systemName: "plus")
          .frame(width: 19, height: 21)
          .foregroundStyle(Color.textBlack)
      }
    }
  }
  
  private var emptyStateView: some View {
    Text("입력된 메모가 없어요")
      .font(.pretendardMedium_16)
      .foregroundStyle(Color.textBright)
      .padding(.horizontal, 14)
      .padding(.vertical, 8)
  }
  
  private var memoList: some View {
    VStack(spacing: 8) {
      ForEach(memos, id: \.self) { memo in
        MemoItemView(
          memo: memo,
          onEdit: { onEdit(memo, $0) },
          onDelete: { onDelete(memo) }
        )
      }
    }
  }
}

// MARK: - Memo Item View
private struct MemoItemView: View {
  let memo: String
  let onEdit: (String) -> Void
  let onDelete: () -> Void
  
  var body: some View {
    Menu {
      Button {
        onEdit(memo)
      } label: {
        Label("메모 수정하기", systemImage: "pencil")
      }
      
      Button(role: .destructive) {
        onDelete()
      } label: {
        Label("메모 삭제하기", systemImage: "trash")
      }
    } label: {
      HStack {
        Text(memo)
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.textBlack)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 14)
          .padding(.vertical, 18)
      }
      .background(
        RoundedRectangle(cornerRadius: 5)
          .stroke(Color.textBrighter, lineWidth: 1)
      )
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Fixed Expense Section View
struct FixedExpenseSectionView: View {
  // MARK: - Properties
  let expenses: [TransactionItem]
  
  // MARK: - Body
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
  
  // MARK: - Subviews
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
  CalendarDailyView(
    viewModel: DIContainer.shared.makeCalendarViewModel(),
    dailyBudget: DailyBudget(
      date: Date(),
      harubee: 50000,
      memo: ["테스트 메모"],
      expense: 60000,
      income: 1000
    )
  )
}

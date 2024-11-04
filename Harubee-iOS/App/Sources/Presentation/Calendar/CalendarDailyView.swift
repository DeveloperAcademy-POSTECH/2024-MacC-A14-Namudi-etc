//
//  CalendarDailyView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Calendar Daily View
struct CalendarDailyView: View {
  let viewModel: CalendarViewModel
  let dayInfo: CalendarData.DayInfo
  
  @State private var activeSheet: SheetType?
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
  
  var body: some View {
    VStack(spacing: 0) {
      HarubeeSectionView(
        harubee: dayInfo.harubee,
        onTap: { activeSheet = .harubeeAdjust }
      )
      .padding(.top, 16)
      .padding(.horizontal, 16)
      
      TransactionSectionView(
        income: dayInfo.income,
        expense: dayInfo.expense,
        onIncomeEdit: { activeSheet = .transactionIncome },
        onExpenseEdit: { activeSheet = .transactionExpense }
      )
      .padding(.top, 16)
      .padding(.horizontal, 16)
      
      MemoSectionView(
        memos: dayInfo.memos,
        onAdd: handleMemoAdd,
        onEdit: handleMemoEdit,
        onDelete: handleMemoDelete
      )
      .padding(.top, 30)
      .padding(.horizontal, 16)
      
      FixedExpenseSectionView(expenses: dayInfo.fixedExpenses)
    }
    .frame(height: UIWindow().bounds.height)
    .sheet(item: $activeSheet) { type in
      switch type {
      case .harubeeAdjust:
        HarubeeAdjustView()
          .presentationDetents([.fraction(0.75)])
        
      case .transactionIncome:
        TransactionInputView(isFocusedExpense: true)
          .presentationDetents([.fraction(0.75)])
        
      case .transactionExpense:
        TransactionInputView(isFocusedExpense: false)
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
  
  private func handleMemoAdd(_ memo: String) {
    viewModel.send(.saveMemo(dayInfo, memo))
  }
  
  private func handleMemoEdit(oldMemo: String, newMemo: String) {
    viewModel.send(.saveMemo(dayInfo, newMemo))
  }
  
  private func handleMemoDelete(_ memo: String) {
    viewModel.send(.deleteMemo(dayInfo, memo))
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
            .padding(.leading, 14)
          
          Spacer()
          
          Text("\(harubee.formatted(.number))원")
            .font(.pretendardSemibold_18)
            .foregroundStyle(Color.main)
            .padding(.trailing, 14)
        }
      }
    }
  }
}

// MARK: - Transaction Section View
struct TransactionSectionView: View {
  let income: Int?
  let expense: Int?
  let onIncomeEdit: () -> Void
  let onExpenseEdit: () -> Void
  
  var body: some View {
    HStack(spacing: 9) {
      transactionCard(
        title: "수입",
        amount: income ?? 0,
        action: onIncomeEdit
      )
      
      transactionCard(
        title: "지출",
        amount: expense ?? 0,
        action: onExpenseEdit
      )
    }
    .frame(height: 84)
  }
  
  private func transactionCard(
    title: String,
    amount: Int,
    action: @escaping () -> Void
  ) -> some View {
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
          
          Text("\(amount.formatted(.number))원")
            .font(.pretendardSemibold_18)
            .foregroundStyle(Color.textBlack)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 14)
        }
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
    VStack(spacing: 8) {
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
      .padding(.horizontal, 6)
      
      if memos.isEmpty {
        emptyStateView
      } else {
        memoList
      }
    }
  }
  
  private var emptyStateView: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.textBrighter, lineWidth: 1)
        .frame(height: 52)
      
      Text("메모가 없습니다")
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.textBright)
    }
  }
  
  private var memoList: some View {
    ScrollView {
      VStack(spacing: 8) {
        ForEach(memos, id: \.self) { memo in
          Menu {
            Button {
              onEdit(memo, memo)
            } label: {
              Label("메모 수정하기", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
              onDelete(memo)
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
                .padding(.vertical, 8)
            }
            .background(
              RoundedRectangle(cornerRadius: 5)
                .stroke(Color.textBrighter, lineWidth: 1)
            )
          }
          .buttonStyle(.plain)
        }
      }
    }
    .frame(maxHeight: 150)
  }
}

// MARK: - Fixed Expense Section View
struct FixedExpenseSectionView: View {
  let expenses: [CalendarData.FixedExpenseItem]
  
  var body: some View {
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
      
      if expenses.isEmpty {
        Text("예정된 고정 지출이 없습니다")
          .font(.pretendardMedium_14)
          .foregroundStyle(Color.textBright)
          .padding(.top, 22)
          .padding(.horizontal, 22)
      } else {
        VStack(spacing: 14) {
          ForEach(expenses) { expense in
            HStack {
              Text(expense.name)
                .font(.pretendardMedium_14)
                .foregroundStyle(Color.textBlack)
              
              Spacer()
              
              Text("\(expense.amount.decimalWithWon)")
                .font(.pretendardSemibold_14)
                .foregroundStyle(Color.redDefault)
            }
            .padding(.horizontal, 22)
          }
        }
        .padding(.top, 22)
      }
    }
  }
}

#Preview {
  CalendarView(viewModel: DIContainer.shared.makeCalendarViewModel())
}

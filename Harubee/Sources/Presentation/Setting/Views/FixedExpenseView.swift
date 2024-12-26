//
//  FixedExpensesView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedExpenseView: View {
  let settingViewModel: SettingViewModel
  
  @State private var isInfoBubbleVisible: Bool = false
  
  private var salaryBudget: SalaryBudget {
    settingViewModel.state.salaryBudget
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        FixedExpenseHeaderView(
          fixedExpenses: salaryBudget.fixedExpenses
        )
        
        FixedExpenseListView(
          settingViewModel: settingViewModel,
          fixedExpenses: .init(
            get: {
              salaryBudget.fixedExpenses
            }, set: { items in
              settingViewModel.send(.updateFixedExpenses(items))
            }),
          isInfoBubbleVisible: $isInfoBubbleVisible
        )
        .padding(.top, 45)
      }
      .frame(maxHeight: .infinity, alignment: .top)
      
      if isInfoBubbleVisible {
        Color.clear
          .contentShape(Rectangle())
          .ignoresSafeArea()
          .onTapGesture { isInfoBubbleVisible.toggle() }
      }
    }
    .navigationBarStyle(
      .white(title: "고정지출 관리", backTitle: "뒤로")
    ) {
      ToolbarItem(placement: .topBarTrailing) {
        HelpButton(
          infoBubbleVisible: $isInfoBubbleVisible,
          buttonColor: .textBlack
        )
      }
    }
  }
}

private struct FixedExpenseHeaderView: View {
  let fixedExpenses: [TransactionItem]
  
  var body: some View {
    VStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 10) {
        Text("총 \(fixedExpenses.count)건")
        Text("총 \(fixedExpenses.reduce(0) { $0 + $1.price }.decimalWithWon)")
      }
      .font(.pretendardSemibold_22)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 26)
      .padding(.top, 44)
    }
  }
}

private struct FixedExpenseListView: View {
  @Environment(MainCoordinator.self) private var coordinator
  let settingViewModel: SettingViewModel
  
  @State private var selectedItem: TransactionItem?
  @Binding var fixedExpenses: [TransactionItem]
  @Binding var isInfoBubbleVisible: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      listHeaderView
      .padding(.leading, 20)
      .foregroundStyle(Color.textBlack)
      
      if fixedExpenses.isEmpty {
        emptyListAnnounce
      } else {
        List {
          ForEach(fixedExpenses, id: \.id) { item in
            fixedExpensesRow(for: item)
              .tapFeedback(tappedBackgroundColor: .clear) {
                self.selectedItem = item
                coordinator.presentFixedExpenseManageSheet(
                  day: item.day,
                  name: item.name,
                  amount: item.price.decimalWithWon
                ) { day, name, price in
                  saveFixedExpense(
                    day: day,
                    name: name,
                    price: price
                  )
                }
              }
          }
          .onDelete(perform: removeList)
        }
        .listStyle(.plain)
        .scrollBounceBehavior(.basedOnSize)
      }
    }
    .onChange(of: selectedItem) { _, _ in }
  }
  
  private var listHeaderView: some View {
    HStack(spacing: 0) {
      Text("목록")
        .font(.pretendardSemibold_16)
      
      Spacer()
      
      Button {
        self.selectedItem = nil
        coordinator.presentFixedExpenseManageSheet(
          day: 1,
          name: "",
          amount: ""
        ) { day, name, price in
          saveFixedExpense(
            day: day,
            name: name,
            price: price
          )
        }
      } label: {
        Image(systemName: "plus")
          .frame(width: 30, height: 21)
      }
      .infoBubble($isInfoBubbleVisible)
      .padding(.trailing, 10)
    }
  }
  
  private var emptyListAnnounce: some View {
    Text("목록을 추가해주세요")
      .font(.pretendardMedium_16)
      .foregroundStyle(Color.textBlack30)
      .padding(.top, 150)
  }
  
  private func fixedExpensesRow(
    for item: TransactionItem
  ) -> some View {
    HStack(spacing: 0) {
      Text("매달 \(item.day)일")
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.textBlack)
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(Color.textBrighter30)
        )
      
      Spacer()
      
      VStack(alignment: .trailing, spacing: 0) {
        Text(item.name)
          .font(.pretendardMedium_12)
          .foregroundStyle(Color.textBlack)
        Text(item.price.decimalWithWon)
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
      }
    }
    .padding(.vertical, 1)
    .contentShape(Rectangle())
  }
  
  private func saveFixedExpense(
    day: Int,
    name: String,
    price: String
  ) {
    let date = Date.convertDateBetweenStartAndEnd(
      start: settingViewModel.state.salaryBudget.startDate,
      end: settingViewModel.state.salaryBudget.endDate,
      day: day
    )
    
    if let item = selectedItem,
       let index = fixedExpenses.firstIndex(where: {
         $0.id == item.id
       }) {
      fixedExpenses[index].date = date
      fixedExpenses[index].day = day
      fixedExpenses[index].name = name
      fixedExpenses[index].price = price.numberFormat ?? 0
    } else {
      fixedExpenses.append(.init(
        date: date,
        day: day,
        name: name,
        price: price.numberFormat ?? 0
      ))
    }
  }
  
  private func removeList(at offsets: IndexSet) {
    fixedExpenses.remove(atOffsets: offsets)
  }
}


// MARK: - InfoBubbles Modifiers
private extension View {
  func infoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .infoBubble(isVisible: isVisible, alignment: .topTrailing) {
        VStack(alignment: .leading, spacing: 2) {
          Text("저축, 구독비, 보험료, 월세, 카드 할부금 등")
          Text("매달 고정으로 나가는 지출을 추가할 수 있어요")
        }
        .font(.pretendardSemibold_12)
        .foregroundStyle(Color.textBlack)
      }
  }
}

#Preview {
  FixedExpenseView(
    settingViewModel: DIContainer.shared.makeSettingViewModel(
      salaryBudget: SalaryBudget.default
    )
  )
}

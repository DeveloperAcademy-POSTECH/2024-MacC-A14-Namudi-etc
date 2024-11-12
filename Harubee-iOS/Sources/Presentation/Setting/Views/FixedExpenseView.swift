//
//  FixedExpensesView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedExpenseView: View {
  private var settingViewModel: SettingViewModel
  @State private var mode: Mode = .add
  @State private var isInfoBubbleVisible: Bool = false
  
  init(settingViewModel: SettingViewModel) {
    self.settingViewModel = settingViewModel
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HeaderView(
          fixedExpenses: settingViewModel.state.salaryBudget?.fixedExpenses ?? []
        )
        FixedExpensesListView(
          settingViewModel: settingViewModel,
          fixedExpenses: .init(
            get: {
              settingViewModel.state.salaryBudget?.fixedExpenses ?? []
            }, set: { items in
              settingViewModel.send(.updateFixedExpenses(items))
            }),
          isInfoBubbleVisible: $isInfoBubbleVisible
        )
        .padding(.top, 33)
      }
      .frame(maxHeight: .infinity, alignment: .top)
      .navigationBarStyle(.white(title: "고정지출 관리", backTitle: "뒤로"))
      
      if isInfoBubbleVisible {
        Color.clear
          .contentShape(Rectangle())
          .ignoresSafeArea()
          .onTapGesture {
            
            isInfoBubbleVisible.toggle()
          }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          isInfoBubbleVisible.toggle()
        } label: {
          Image(systemName: "questionmark.circle")
            .font(Font.system(size: 18, weight: .regular))
            .foregroundStyle(Color.textBlack)
        }
      }
    }
  }
}

private struct HeaderView: View {
  private var fixedExpenses: [TransactionItem]
  
  init(fixedExpenses: [TransactionItem]) {
    self.fixedExpenses = fixedExpenses
  }
  
  var body: some View {
    VStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 10) {
        Text("총 \(fixedExpenses.count)건")
        Text("총 \(fixedExpenses.reduce(0) { $0 + $1.price }.decimalWithWon)")
      }
      .font(.pretendardSemibold_24)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 26)
      .padding(.top, 44)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
        .padding(.horizontal, 18)
    }
  }
}

private struct FixedExpensesListView: View {
  private var settingViewModel: SettingViewModel
  
  @State private var isPresented: Bool = false
  @Binding private var fixedExpenses: [TransactionItem]
  @Binding private var isInfoBubbleVisible: Bool
  
  @State private var manageMode: Mode
  @State private var selectedItem: TransactionItem?
  
  init(
    settingViewModel: SettingViewModel,
    fixedExpenses: Binding<[TransactionItem]>,
    isInfoBubbleVisible: Binding<Bool>
  ) {
    self.settingViewModel = settingViewModel
    self._fixedExpenses = fixedExpenses
    self._manageMode = State(initialValue: .add)
    self._isInfoBubbleVisible = isInfoBubbleVisible
  }
  
  var body: some View {
    VStack {
      HStack(spacing: 0) {
        Text("목록")
          .font(.pretendardSemibold_16)
        
        Spacer()
        
        Button {
          self.manageMode = .add
          self.selectedItem = nil
          self.isPresented = true
        } label: {
          Image(systemName: "plus")
            .frame(width: 30, height: 21)
        }
        .infoBubble(isVisible: $isInfoBubbleVisible, alignment: .topTrailing) {
          VStack(alignment: .leading, spacing: 2) {
            Text("저축, 구독비, 보험료, 월세, 카드 할부금 등")
            Text("매달 고정으로 나가는 지출을 추가할 수 있어요")
          }
          .font(.pretendardSemibold_12)
          .foregroundStyle(Color.textBlack)
        }
        .padding(.trailing, 10)

      }
      .padding(.leading, 20)
      .foregroundStyle(Color.textBlack)
      
      if fixedExpenses.isEmpty {
        Text("목록을 추가해주세요")
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.textBlack30)
          .padding(.top, 150)
        
      } else {
        List {
          ForEach(fixedExpenses, id: \.id) { item in
            HStack(spacing: 0) {
              Text("매달 \(item.date.formattedDateToString(.d))")
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
            .onTapGesture {
              self.manageMode = .modify
              self.selectedItem = item
              self.isPresented = true
            }
          }
          .onDelete(perform: removeList)
        }
        .listStyle(.plain)
        .scrollBounceBehavior(.basedOnSize)
      }
    }
    .sheet(isPresented: $isPresented) {
      FixedExpenseManageView(
        mode: self.manageMode,
        selectedDay: selectedItem?.date.day ?? 1,
        fixedExpenseName: selectedItem?.name ?? "",
        fixedExpenseAmount: selectedItem?.price.decimal ?? ""
      ) { day, name, price in
        let date = day.convertDateBetweenStartAndEnd(
          start: settingViewModel.state.salaryBudget?.startDate ?? Date(),
          end: settingViewModel.state.salaryBudget?.endDate ?? Date()
        )
        
        if let item = selectedItem {
          if let index = fixedExpenses.firstIndex(where: { $0.id == item.id }) {
            fixedExpenses[index].date = date
            fixedExpenses[index].name = name
            fixedExpenses[index].price = price.numberFormat ?? 0
          }
        } else {
          fixedExpenses.append(.init(
            date: date,
            name: name,
            price: price.numberFormat ?? 0)
          )
        }
      }
      .presentationDetents([.fraction(0.8)])
      .presentationCornerRadius(20)
    }
    .onChange(of: selectedItem) { _, _ in }
    .onChange(of: fixedExpenses) { _, _ in
      fixedExpenses.sort(by: {
        $0.date.day < $1.date.day
      })
    }
  }
  
  func removeList(at offsets: IndexSet) {
    fixedExpenses.remove(atOffsets: offsets)
  }
}



//#Preview {
//  FixedExpenseView(settingViewModel: DIContainer.shared.makeSettingViewModel(salaryBudget: SalaryBudget(
//          startDate: Date(),
//          endDate: Date(),
//          fixedIncome: 1_000_000,
//          fixedExpenses: [],
//          balance: 0,
//          defaultHarubee: 0,
//          dailyBudgets: []
//        )))
//}

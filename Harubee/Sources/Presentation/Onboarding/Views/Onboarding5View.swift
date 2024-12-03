//
//  Onboarding5View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding5View: View {
  private var viewModel: OnboardingViewModel
  
  @State private var fixedExpenses: [TransactionItem] = []
  
  @State private var isPresented: Bool = false
  
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView(harubee: viewModel.state.averageHarubee)
      
      onboardingBodyTitleView
        .padding(.top, 30)
        .padding(.horizontal, 20)
      
      FixedExpenseListView(
        viewModel: viewModel,
        fixedExpenses: $fixedExpenses
      )
        .padding(.top, 32)
      
      
      Spacer()
      
      MainColorBottomButton(title: "다음으로") {
        self.isPresented = true
      }
    }
    .onAppear {
      viewModel.send(.onAppearOnboardingStep5)
      self.fixedExpenses = viewModel.state.fixedExpenses
    }
    .onChange(of: fixedExpenses, { _, _ in
      viewModel.send(.updateFixedExpenses(fixedExpenses))
    })
    .navigationDestination(isPresented: $isPresented) {
      Onboarding6View(viewModel: viewModel)
        .navigationBarBackButtonHidden()
    }
  }
  
  private var onboardingBodyTitleView: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("매달 고정으로 나가는 지출 목록을")
      Text("입력해주세요 (예: 월세, 구독비, 저축)")
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(.pretendardMedium_20)
    .foregroundStyle(Color.textBlack)
  }
}

private struct OnboardingHeaderView: View {
  private let harubee: Int
  
  init(harubee: Int) {
    self.harubee = harubee
  }
  
  var body: some View {
    VStack(spacing: 28) {
      OnboardingNavigationHeaderView(onboardingPage: .third)
      
      VStack(alignment: .leading, spacing: 6) {
        Text("현재 계산된 하루비는")
        HStack(spacing: 0) {
          Image(.harubeeWhite)
            .resizable()
            .frame(width: 20, height: 20)
          HStack(alignment: .bottom, spacing: 0) {
            Text(harubee.decimalWithWon)
              .padding(.leading, 6)
              .font(.pretendardSemibold_28)
            Text("입니다")
              .padding(.bottom, 1)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.pretendardSemibold_24)
      .foregroundStyle(Color.whiteDefault)
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 26)
    .background(
      Rectangle().fill(Color.main).ignoresSafeArea()
    )
  }
}

private struct FixedExpenseListView: View {
  let viewModel: OnboardingViewModel
  
  @State private var manageMode: Mode = .add
  @State private var selectedItem: TransactionItem?
  @State private var isPresented: Bool = false
  @Binding var fixedExpenses: [TransactionItem]
  
  var body: some View {
    VStack(spacing: 0) {
      listHeaderView
        .padding(.horizontal, 22)
        .foregroundStyle(Color.textBlack)
      
      if fixedExpenses.isEmpty {
        emptyListAnnounce
      } else {
        List {
          ForEach(fixedExpenses, id: \.id) { item in
            fixedExpensesRow(for: item)
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
        saveFixedExpense(
          day: day,
          name: name,
          price: price
        )
      }
      .presentationDetents([.large])
      .presentationCornerRadius(20)
    }
    .onChange(of: selectedItem) { _, _ in }
    .onChange(of: fixedExpenses) { _, _ in
      fixedExpenses.sort(by: {
        $0.date.day < $1.date.day
      })
    }
  }
  
  private var listHeaderView: some View {
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
      Text("매달 \(item.date.formattedDateToString(.day_kr))")
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
    let date = day.convertDateBetweenStartAndEnd(
      start: viewModel.state.incomeStartDate,
      end: viewModel.state.incomeEndDate
    )
    
    if let item = selectedItem,
       let index = fixedExpenses.firstIndex(where: {
         $0.id == item.id
       }) {
      fixedExpenses[index].date = date
      fixedExpenses[index].name = name
      fixedExpenses[index].price = price.numberFormat ?? 0
    } else {
      fixedExpenses.append(.init(
        date: date,
        name: name,
        price: price.numberFormat ?? 0
      ))
    }
  }
  
  private func removeList(at offsets: IndexSet) {
    fixedExpenses.remove(atOffsets: offsets)
  }
}

#Preview {
  Onboarding5View(viewModel: DIContainer.shared.makeOnboardingViewModel())
}

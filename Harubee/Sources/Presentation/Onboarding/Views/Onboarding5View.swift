//
//  Onboarding5View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding5View: View {
  @Environment(OnboardingCoordinator.self) private var coordinator
  @Environment(OnboardingViewModel.self) private var viewModel
  
  @State var fixedExpenses: [TransactionItem]

  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView(harubee: viewModel.state.averageHarubee)
      
      OnboardingBodyTitleView()
        .padding(.top, 30)
        .padding(.horizontal, 20)
      
      FixedExpenseListView(
        viewModel: viewModel,
        fixedExpenses: $fixedExpenses
      )
        .padding(.top, 32)
      
      
      Spacer()
      
      MainColorBottomButton(title: "다음으로") {
        coordinator.push(.onboarding6)
      }
    }
    .background(.bgPrimary)
    .navigationBarStyle(.onboarding, toolbar: {
      ToolbarItem(placement: .topBarTrailing) {
        Text("3/3")
          .font(.pretendardSemibold_22)
          .foregroundStyle(.textSecondaryInversion)
      }
    })
    .onChange(of: fixedExpenses, { _, _ in
      viewModel.send(.updateFixedExpenses(fixedExpenses))
    })
  }
}

private struct OnboardingHeaderView: View {
  let harubee: Int
  
  var body: some View {
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
    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
    .font(.pretendardSemibold_24)
    .foregroundStyle(.textFixed)
    .padding(.horizontal, 20)
    .background(.bgAccent)
  }
}

private struct OnboardingBodyTitleView: View {
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("매달 고정으로 나가는 지출 목록을")
      Text("입력해주세요 (예: 월세, 구독비, 저축)")
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(.pretendardMedium_20)
    .foregroundStyle(.textFixed)
  }
}

private struct FixedExpenseListView: View {
  @Environment(OnboardingCoordinator.self) private var coordinator
  let viewModel: OnboardingViewModel
  
  @State private var selectedItem: TransactionItem?
  @Binding var fixedExpenses: [TransactionItem]
  
  var body: some View {
    VStack(spacing: 0) {
      listHeaderView
        .padding(.horizontal, 22)
        .foregroundStyle(.textPrimary)
      
      if fixedExpenses.isEmpty {
        emptyListAnnounce
      } else {
        List {
          ForEach(fixedExpenses, id: \.id) { item in
            Button {
              self.selectedItem = item
              coordinator.presentFixedExpenseManageSheet(
                day: item.day,
                name: item.name,
                amount: item.price.decimalWithWon
              ) { day, name, price in
                saveFixedExpense(day: day, name: name, price: price)
              }
            } label: {
              fixedExpensesRow(for: item)
            }
            .listRowBackground(Color.clear)
            .buttonStyle(CustomButtonStyle(
              haptic: .tap
            ))
          }
          .onDelete(perform: removeList)
        }
        .listStyle(.plain)
        .scrollBounceBehavior(.basedOnSize)
      }
    }
    .onChange(of: fixedExpenses) { _, _ in
      fixedExpenses.sort(by: {
        $0.day < $1.day
      })
    }
  }
  
  private var listHeaderView: some View {
    HStack(spacing: 0) {
      Text("목록")
        .font(.pretendardSemibold_16)
      
      Spacer()
      
      Button {
        selectedItem = nil
        coordinator.presentFixedExpenseManageSheet(
          day: 1,
          name: "",
          amount: ""
        ) { day, name, price in
          saveFixedExpense(day: day, name: name, price: price)
        }
      } label: {
        Image(systemName: "plus")
          .frame(width: 30, height: 21)
      }
      .buttonStyle(CustomButtonStyle(
        haptic: .tap
      ))
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
        .foregroundStyle(.textPrimary)
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(.textTertiary30)
        )
      
      Spacer()
      
      VStack(alignment: .trailing, spacing: 0) {
        Text(item.name)
          .font(.pretendardMedium_12)
        Text(item.price.decimalWithWon)
          .font(.pretendardSemibold_18)
      }.foregroundStyle(.textPrimary)
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
      start: viewModel.state.incomeStartDate,
      end: viewModel.state.incomeEndDate,
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

#Preview {
  Onboarding5View(
    fixedExpenses: []
  )
  .environment(DIContainer.shared.makeOnboardingViewModel())
  .environment(OnboardingCoordinator())
}

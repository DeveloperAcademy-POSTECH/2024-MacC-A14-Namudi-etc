//
//  Onboarding5View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Domain
import Shared

struct Onboarding5View: View {
  private var viewModel: OnboardingViewModel
  
  @State private var fixedExpenses: [TransactionItem]
  
  @State private var isPresented: Bool = false
  
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    self._fixedExpenses = .init(initialValue: viewModel.state.fixedExpenses)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      OnboardingHeaderView(harubee: viewModel.state.averageHarubee)
      
      OnboardingBodyView()
        .padding(.top, 30)
        .padding(.horizontal, 20)
      
      FixedExpensesListView(
        viewModel: viewModel,
        fixedExpenses: $fixedExpenses
      )
        .padding(.top, 30)
      
      
      Spacer()
      
      MainColorButton(title: "다음으로") {
        self.isPresented = true
      }
      .clipShape(
        RoundedRectangle(cornerRadius: 10)
      )
      .padding(.horizontal, 16)
      .padding(.bottom, 9)
    }
    .onChange(of: fixedExpenses, { _, _ in
      viewModel.send(.updateFixedExpenses(fixedExpenses))
    })
    .navigationDestination(isPresented: $isPresented) {
      Onboarding6View()
        .navigationBarBackButtonHidden()
    }
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
          Image.harubeeWhite
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

private struct OnboardingBodyView: View {
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("매달 고정으로 나가는 지출 목록을")
      Text("입력해주세요 (예: 월세, 구독비, 저축)")
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(.pretendardMedium_20)
    .foregroundStyle(Color.textBlack)
  }
}

private struct FixedExpensesListView: View {
  private var viewModel: OnboardingViewModel
  
  @State private var isPresented: Bool = false
  @Binding private var fixedExpenses: [TransactionItem]
  
  @State private var manageMode: Mode
  @State private var selectedItem: TransactionItem?
  
  init(
    viewModel: OnboardingViewModel,
    fixedExpenses: Binding<[TransactionItem]>
  ) {
    self.viewModel = viewModel
    self._fixedExpenses = fixedExpenses
    self._manageMode = State(initialValue: .add)
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
            .frame(width: 19, height: 21)
        }
      }
      .padding(.horizontal, 20)
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
          start: viewModel.state.incomeStartDate,
          end: viewModel.state.incomeEndDate
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

#Preview {
  Onboarding5View(viewModel: DIContainer.shared.makeOnboardingViewModel())
}

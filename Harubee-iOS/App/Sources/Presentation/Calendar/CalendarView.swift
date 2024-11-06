//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Domain

struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  @State private var navigateToDailyView = false
  
  init(viewModel: CalendarViewModel) {
    _viewModel = State(initialValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      Color.whiteDefault.ignoresSafeArea()
      
      VStack(spacing: 0) {
        CalendarHeader(
          year: viewModel.state.currentBudget?.startDate.yearString ?? "",
          period: viewModel.periodTitle,
          canMovePrevious: viewModel.canMovePrevious,
          canMoveNext: viewModel.canMoveNext,
          onMove: { direction in
            viewModel.send(.movePeriod(direction))
          }
        )
        
        if let budget = viewModel.state.currentBudget {
          CalendarContent(
            budget: budget,
            selectedDate: viewModel.state.selectedDate,
            onDateSelect: { date in
              viewModel.send(.selectDate(date))
              navigateToDailyView = true
            }
          )
        }
      }
    }
    .navigationDestination(isPresented: $navigateToDailyView) {
      if let dailyBudget = viewModel.selectedDailyBudget {
        CalendarDailyView(
          viewModel: viewModel,
          dailyBudget: dailyBudget
        )
      }
    }
    .navigationTitle("캘린더")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.send(.initialData)
      viewModel.send(.selectDate(Date()))
    }
    .alert("오류", isPresented: .constant(viewModel.state.error != nil)) {
      Button("확인", role: .cancel) {}
    } message: {
      Text(viewModel.state.error?.localizedDescription ?? "")
    }
  }
}

// MARK: - Calendar Header
struct CalendarHeader: View {
  let year: String
  let period: String
  let canMovePrevious: Bool
  let canMoveNext: Bool
  let onMove: (PeriodDirection) -> Void
  
  var body: some View {
    VStack(spacing: 3) {
      Text(year)
        .font(.pretendardMedium_12)
      
      HStack(alignment: .center, spacing: 38) {
        navigationButton(direction: .previous)
        
        Text(period)
          .font(.pretendardSemibold_24)
          .frame(maxWidth: .infinity)
        
        navigationButton(direction: .next)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 22)
    .padding(.bottom, 15)
    .padding(.horizontal, 50)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
  }
  
  private func navigationButton(direction: PeriodDirection) -> some View {
    let isEnabled = direction == .next ? canMoveNext : canMovePrevious
    
    return Button {
      onMove(direction)
    } label: {
      Image(systemName: direction.imageName)
        .font(.custom("SF Pro", size: 16))
        .opacity(isEnabled ? 1 : 0)
    }
    .disabled(!isEnabled)
  }
}

// MARK: - Calendar Content
struct CalendarContent: View {
  let budget: SalaryBudget
  let selectedDate: Date?
  let onDateSelect: (Date) -> Void
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 25) {
        CalendarGrid(
          startDate: budget.startDate,
          endDate: budget.endDate,
          selectedDate: selectedDate,
          onCellSelect: onDateSelect
        ) { date in
          CalendarCell(
            date: date,
            defaultHarubee: Int(budget.defaultHarubee),
            dailyBudget: budget.dailyBudgets.first {
              $0.date.isSameDay(as: date)
            }
          )
        }
        .padding(.top, 18)
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

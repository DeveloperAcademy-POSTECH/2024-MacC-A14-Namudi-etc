//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Domain

// MARK: - Periodly Calendar View
struct PeriodlyCalendarView: View {
  @State private var viewModel: CalendarViewModel
  @State private var navigateToDailyView = false
  
  // MARK: - Initialization
  init(viewModel: CalendarViewModel) {
    self._viewModel = State(initialValue: viewModel)
  }
  
  // MARK: - Body
  var body: some View {
    ZStack {
      Color.whiteDefault.ignoresSafeArea()
      
      VStack(spacing: 0) {
        if let budget = viewModel.state.currentBudget {
          CalendarHeader(
            year: budget.startDate.yearString,
            period: viewModel.periodTitle,
            navigationState: viewModel.navigationState,
            onNavigate: handlePeriodNavigation
          )
          
          CalendarContent(
            budget: budget,
            onDateSelect: handleDateSelection
          )
        }
      }
      
      if !viewModel.isCurrentPeriodContainsToday {
        ReturnToTodayButton(
          title: "이번 기간으로 돌아가기",
          action: handleReturnToToday
        )
      }
    }
    .navigationDestination(isPresented: $navigateToDailyView) {
      if let selectedDate = viewModel.state.selectedDate {
        DailyCalendarView(
          viewModel: viewModel,
          initialDate: selectedDate
        )
      }
    }
    .applyNavigationBarStyle()
    .onAppear { viewModel.send(.loadInitialData) }
    .errorAlert(error: viewModel.state.error)
  }
  
  // MARK: - Event Handlers
  private func handlePeriodNavigation(_ direction: PeriodDirection) {
    viewModel.send(.movePeriod(direction))
  }
  
  private func handleDateSelection(_ date: Date) {
    viewModel.send(.selectDate(date))
    navigateToDailyView = true
  }
  
  private func handleReturnToToday() {
    viewModel.send(.moveToCurrent)
  }
}

// MARK: - Calendar Header
private struct CalendarHeader: View {
  let year: String
  let period: String
  let navigationState: CalendarViewModel.NavigationState
  let onNavigate: (PeriodDirection) -> Void
  
  var body: some View {
    VStack(spacing: 0) {
      yearLabel
      periodNavigator
    }
    .frame(maxWidth: .infinity)
    .frame(height: 82)
    .padding(.horizontal, 30)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
  }
  
  private var yearLabel: some View {
    Text(year)
      .font(.pretendardMedium_12)
      .padding(.bottom, -5)
  }
  
  private var periodNavigator: some View {
    HStack(alignment: .center, spacing: 38) {
      PeriodNavigationButton(
        direction: .previous,
        isEnabled: navigationState.canMovePrevious,
        onTap: onNavigate
      )
      
      periodLabel
      
      PeriodNavigationButton(
        direction: .next,
        isEnabled: navigationState.canMoveNext,
        onTap: onNavigate
      )
    }
  }
  
  private var periodLabel: some View {
    Text(period)
      .font(.pretendardSemibold_24)
      .frame(maxWidth: .infinity)
  }
}

// MARK: - Period Navigation Button
private struct PeriodNavigationButton: View {
  let direction: PeriodDirection
  let isEnabled: Bool
  let onTap: (PeriodDirection) -> Void
  
  var body: some View {
    Image(systemName: direction.imageName)
      .font(.system(size: 16))
      .opacity(isEnabled ? 1 : 0)
      .frame(width: 44, height: 44)
      .contentShape(Rectangle())
      .tapFeedback {
        onTap(direction)
      }
      .disabled(!isEnabled)
  }
}

// MARK: - Calendar Content
private struct CalendarContent: View {
  let budget: SalaryBudget
  let onDateSelect: (Date) -> Void
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 25) {
        CalendarGrid(
          startDate: budget.startDate,
          endDate: budget.endDate
        ) { date in
          CalendarCell(
            date: date,
            defaultHarubee: Int(budget.defaultHarubee),
            dailyBudget: budget.dailyBudgets.first {
              $0.date.isSameDay(as: date)
            },
            onSelect: onDateSelect
          )
        }
        .padding(.top, 18)
      }
    }
  }
}

// MARK: - Return To Today Button
struct ReturnToTodayButton: View {
  let title: String
  let action: () -> Void
  
  var body: some View {
    VStack {
      Spacer()
      Button {
        HapticManager.shared.trigger(.tap)
        action()
      } label: {
        HStack(spacing: 4) {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: 14))
          Text(title)
            .font(.pretendardMedium_14)
        }
        .foregroundColor(.whiteDefault)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
          Capsule()
            .fill(Color.mainBright)
            .shadow(
              color: .black.opacity(0.15),
              radius: 4,
              y: 2
            )
        )
      }
      .padding(.bottom, 14)
    }
  }
}

// MARK: - View Modifiers
private extension View {
  func applyNavigationBarStyle() -> some View {
    self.navigationBarStyle(.main(title: "캘린더", backTitle: ""))
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          HelpButton()
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

// MARK: - Help Button
private struct HelpButton: View {
  var body: some View {
    Image(systemName: "questionmark.circle")
      .foregroundStyle(Color.whiteDefault)
      .tapFeedback { }
  }
}

// MARK: - Preview
#Preview {
  NavigationStack {
    PeriodlyCalendarView(viewModel: DIContainer.shared.makeCalendarViewModel())
  }
}

//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Periodly Calendar View
struct PeriodlyCalendarView: View {
  @State private var viewModel: CalendarViewModel
  @State private var navigateToDailyView: Bool = false
  @State private var infoBubbleVisible: Bool = false
  
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
            periodDirectionState: viewModel.periodDirectionState,
            onNavigate: handlePeriodDirection,
            infoBubbleVisible: $infoBubbleVisible
          )
          .zIndex(1)
          
          CalendarContent(
            budget: budget,
            onDateSelect: handleDateSelection,
            infoBubbleVisible: $infoBubbleVisible
          )
        }
      }
      
      if !viewModel.isCurrentPeriodContainsToday {
        ReturnToTodayButton(
          title: "이번 기간으로 돌아가기",
          action: handleReturnToToday
        )
      }
      
      if infoBubbleVisible {
        Color.clear
          .contentShape(Rectangle())
          .ignoresSafeArea()
          .onTapGesture {
            infoBubbleVisible = false
          }
      }
    }
    .applyNavigationBarStyle(infoBubbleVisible: $infoBubbleVisible)
    .onAppear { viewModel.send(.loadInitialData) }
    .errorAlert(error: viewModel.state.error)
    .navigationDestination(isPresented: $navigateToDailyView) {
      if let selectedDate = viewModel.state.selectedDate {
        DailyCalendarView(
          viewModel: viewModel,
          initialDate: selectedDate
        )
      }
    }
  }
  
  // MARK: - Action Handlers
  private func handlePeriodDirection(_ direction: PeriodDirection) {
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
  let periodDirectionState: CalendarViewModel.PeriodDirectionState
  let onNavigate: (PeriodDirection) -> Void
  @Binding var infoBubbleVisible: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      yearLabel
      periodDirection
        .titleInfoBubble($infoBubbleVisible)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 82)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
    
  }
  
  private var yearLabel: some View {
    Text(year)
      .font(.pretendardMedium_12)
      .padding(.bottom, -5)
  }
  
  private var periodDirection: some View {
    HStack(alignment: .center, spacing: 8) {
      PeriodDirectionButton(
        direction: .previous,
        isEnabled: periodDirectionState.canMovePrevious,
        onTap: onNavigate
      )
      
      periodLabel
        .frame(width: 160)
      
      PeriodDirectionButton(
        direction: .next,
        isEnabled: periodDirectionState.canMoveNext,
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

// MARK: - Period Direction Button
private struct PeriodDirectionButton: View {
  let direction: PeriodDirection
  let isEnabled: Bool
  let onTap: (PeriodDirection) -> Void
  
  var body: some View {
    Image(systemName: direction.imageName)
      .font(.system(size: 16))
      .foregroundStyle(isEnabled ? Color.whiteDefault : Color.textBrighter30)
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
  @Binding var infoBubbleVisible: Bool
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 25) {
        PeriodlyCalendar(
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
        .hexagonInfoBubble($infoBubbleVisible)
        .harubeeInfoBubble($infoBubbleVisible)
      }
    }
  }
}

// MARK: - View Modifiers
private extension View {
  func applyNavigationBarStyle(
    infoBubbleVisible: Binding<Bool>
  ) -> some View {
    self.navigationBarStyle(.main(title: "캘린더", backTitle: "뒤로"))
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          HelpButton(infoBubbleVisible: infoBubbleVisible)
        }
      }
  }
  
  func errorAlert(error: Error?) -> some View {
    alert("오류", isPresented: .constant(error != nil)) {
      Button("확인", role: .cancel) {
        fatalError()
      }
    } message: {
      if let error = error {
        Text(error.localizedDescription)
      }
    }
  }
}

// MARK: - InfoBubbles Modifiers
private extension View {
  func titleInfoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .infoBubble(
        isVisible: isVisible,
        alignment: .bottom
      ) {
        VStack {
          Text("하루비의 캘린더는 수입일부터 다음 수입일까지로 구성돼요")
        }
        .font(.pretendardMedium_12)
        .foregroundStyle(Color.textBlack)
      }
  }
  
  func hexagonInfoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .overlay(alignment: .top) {
        Color.clear
          .frame(width: 55, height: 10)
          .padding(.top, 210)
          .infoBubble(
            isVisible: isVisible,
            alignment: .bottom
          ) {
            VStack(spacing: 0) {
              HStack(spacing: 0) {
                Text("실제 지출을 입력하면 하루비 대신\n실제 지출이 표시되고, 체크 표시가 나타나요")
                Spacer()
              }
              .padding(.bottom, 8)
              
              HStack(spacing: 0) {
                
                Text("하루비보다 많이 지출했다면 ")
                Text("빨간색 체크")
                  .font(.pretendardSemibold_12)
                  .foregroundStyle(Color.redDefault)
                Image.hexagonBad
                  .resizable()
                  .frame(width: 12, height: 12)
                  .scaledToFit()
                Spacer()
              }
              HStack(spacing: 0) {
                Text("적게 지출했다면 ")
                Text("파란색 체크")
                  .font(.pretendardSemibold_12)
                  .foregroundStyle(Color.main)
                Image.hexagonGood
                  .resizable()
                  .frame(width: 12, height: 12)
                  .scaledToFit()
                Text(" 로 표시돼요")
                Spacer()
              }
            }
            .font(.pretendardMedium_12)
            .foregroundStyle(Color.textBlack)
          }
      }
  }
  
  func harubeeInfoBubble(_ isVisible: Binding<Bool>) -> some View {
    self
      .overlay(alignment: .center) {
        Color.clear
          .frame(width: 55, height: 10)
          .padding(.top, 100)
          .infoBubble(
            isVisible: isVisible,
            alignment: .bottom
          ) {
            VStack {
              HStack(spacing: 0) {
                Text("미래의 날짜 밑에 있는 숫자들은 이 날의 하루비를 의미해요")
                Spacer()
              }
              HStack(spacing: 0) {
                Text("기본 하루비는")
                Text(" 검정색")
                  .font(.pretendardSemibold_12)
                Text(", 조정된 하루비는 ")
                Text("파란색")
                  .font(.pretendardSemibold_12)
                  .foregroundStyle(Color.main)
                Text("으로 표시돼요")
                Spacer()
              }
            }
            .font(.pretendardMedium_12)
            .foregroundStyle(Color.textBlack)
          }
      }
  }
}

// MARK: - Preview
#Preview {
  NavigationStack {
    PeriodlyCalendarView(viewModel: DIContainer.shared.makeCalendarViewModel()
    )
  }
}

//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by assistant on 11/4/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

// MARK: - Calendar View
struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  
  init(viewModel: CalendarViewModel) {
    _viewModel = State(initialValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      Color.whiteDefault.ignoresSafeArea()
      
      VStack(spacing: 0) {
        CalendarHeader(
          year: viewModel.state.currentPeriod.start.yearString,
          period: createPeriodTitle(),
          canMovePrevious: viewModel.state.canMovePreviousPeriod,
          canMoveNext: viewModel.state.canMoveNextPeriod,
          onMove: { direction in
            viewModel.send(.movePeriod(direction))
          }
        )
        
        CalendarContent(
          viewModel: viewModel
        )
      }
    }
    .navigationTitle("캘린더")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.send(.initialData)
      viewModel.send(.dayCellSelected(Date()))
    }
    .alert("오류", isPresented: .constant(viewModel.state.error != nil)) {
      Button("확인", role: .cancel) {}
    } message: {
      Text(viewModel.state.error?.localizedDescription ?? "")
    }
  }
  
  private func createPeriodTitle() -> String {
    let period = viewModel.state.currentPeriod
    return "\(period.start.monthDayString) - \(period.end.monthDayString)"
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
  let viewModel: CalendarViewModel
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(showsIndicators: false) {
        VStack(spacing: 25) {
          CalendarGrid(
            startDate: viewModel.state.currentPeriod.start,
            endDate: viewModel.state.currentPeriod.end,
            selectedDate: viewModel.state.selectedDate,
            onDateSelect: { date in
              viewModel.send(.dayCellSelected(date))
              withAnimation {
                proxy.scrollTo("dailyView", anchor: .bottom)
              }
            }
          ) { date in
            CalendarCell(
              date: date,
              dayInfo: viewModel.state.dayInfos.first {
                $0.date.isSameDay(as: date)
              },
              isSelected: viewModel.state.selectedDate?.isSameDay(as: date) ?? false
            )
          }
          .padding(.top, 18)
          
          if let selectedDate = viewModel.state.selectedDate,
             let dayInfo = viewModel.state.dayInfos.first(where: {
               $0.date.isSameDay(as: selectedDate)
             }) {
            CalendarDailyView(
              viewModel: viewModel,
              dayInfo: dayInfo
            )
            .id("dailyView")
          }
        }
      }
    }
  }
}

#Preview {
  CalendarView(viewModel: DIContainer.shared.makeCalendarViewModel())
}

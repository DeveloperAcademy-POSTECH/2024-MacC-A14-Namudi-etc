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
            withAnimation(.easeInOut(duration: 0.05)) {
              viewModel.send(.movePeriod(direction))
            }
          }
        )
        
        if let budget = viewModel.state.currentBudget {
          CalendarContent(
            budget: budget,
            selectedDate: viewModel.state.selectedDate,
            onCellSelect: { date in
              viewModel.send(.selectDate(date))
              navigateToDailyView = true
            }
          )
        }
      }
      
      if !viewModel.isCurrentPeriodContainsToday {
        moveToCurrentButton
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
    .navigationBarStyle(.main(title: "캘린더", backTitle: ""))
    // TODO: - 도움말 모디파이어 기능 구현
    .toolbar {
      Image(systemName: "questionmark.circle")
        .foregroundStyle(Color.whiteDefault)
        .tapFeedback {
          
        }
    }
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
  
  /*
   TODO: CalendarDailyView와 버튼 합친 후,
   TODO: 아직 지출 및 수입을 입력하지 않은 날이 있어요 기능 구현 필요
   */
  private var moveToCurrentButton: some View {
    VStack(spacing: 0) {
      Spacer()
      Button {
        HapticManager.shared.trigger(.tap)
        withAnimation {
          viewModel.send(.moveToCurrent)
        }
      } label: {
        HStack(spacing: 4) {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: 14))
          Text("이번 기간으로 돌아가기")
            .font(.pretendardMedium_14)
        }
        .foregroundColor(.whiteDefault)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
          Capsule()
            .fill(Color.mainBright)
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        )
      }
      .padding(.bottom, 14)
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
    VStack(spacing: 0) {
      Text(year)
        .font(.pretendardMedium_12)
        .padding(.bottom, -10)
      
      HStack(alignment: .center, spacing: 38) {
        navigationButton(direction: .previous)
        
        Text(period)
          .font(.pretendardSemibold_24)
          .frame(maxWidth: .infinity)
        
        navigationButton(direction: .next)
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: 82)
    .padding(.horizontal, 30)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
  }
  
  private func navigationButton(direction: PeriodDirection) -> some View {
    let isEnabled = direction == .next ? canMoveNext : canMovePrevious
    
    return Image(systemName: direction.imageName)
      .font(.custom("SF Pro", size: 16))
      .opacity(isEnabled ? 1 : 0)
      .frame(width: 44, height: 44)
      .contentShape(Rectangle())
      .tapFeedback {
        onMove(direction)
      }
      .disabled(!isEnabled)
  }
}

// MARK: - Calendar Content
struct CalendarContent: View {
  let budget: SalaryBudget
  let selectedDate: Date?
  let onCellSelect: (Date) -> Void
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 25) {
        CalendarGrid(
          startDate: budget.startDate,
          endDate: budget.endDate,
          selectedDate: selectedDate
        ) { date in
          CalendarCell(
            onSelect: { date in
              onCellSelect(date)
            },
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

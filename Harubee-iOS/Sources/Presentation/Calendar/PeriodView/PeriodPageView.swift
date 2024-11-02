//
//  PeriodPageView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - PeriodPageView View
struct PeriodPageView: View {
  let viewModel: CalendarViewModel
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      CalendarGridView(
        daysInPeriod: createDaysInPeriod(
          start: viewModel.state.currentPeriod.start,
          end: viewModel.state.currentPeriod.end
        ),
        selectedDate: viewModel.state.selectedDate,
        dayInfos: viewModel.state.dayInfos,
        onDateSelected: { date in
          withAnimation {
            viewModel.send(.onDateSelected(date))
          }
        }
      )
      .padding(.top, 18)
      .padding(.horizontal, 14)
    }
  }
  
  /// startDate와 endDate를 받아 캘린더에 표시할 기간을 생성합니다.
  private func createDaysInPeriod(start: Date, end: Date) -> [Date?] {
    let calendar = Calendar.current
    var dates: [Date?] = []
    
    let startWeekday = calendar.component(.weekday, from: start) - 1
    dates += Array(repeating: nil as Date?, count: startWeekday)
    
    var currentDate = start
    while currentDate <= end {
      dates.append(currentDate)
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    let remainingDays = (7 - (dates.count % 7)) % 7
    dates += Array(repeating: nil as Date?, count: remainingDays)
    
    return dates
  }
}

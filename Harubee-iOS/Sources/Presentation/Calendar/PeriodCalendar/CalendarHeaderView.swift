//
//  CalendarHeaderView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - Calendar Header View
struct CalendarHeaderView: View {
  private let periodYearTitle: String
  private let periodTitle: String
  private let canMovePeriod: (previous: Bool, next: Bool)
  private let movePreviousPeriod: () -> Void
  private let moveNextPeriod: () -> Void
  
  init(
    periodYearTitle: String,
    periodTitle: String,
    canMovePeriod: (previous: Bool, next: Bool),
    movePreviousPeriod: @escaping () -> Void,
    moveNextPeriod: @escaping () -> Void
  ) {
    self.periodYearTitle = periodYearTitle
    self.periodTitle = periodTitle
    self.canMovePeriod = canMovePeriod
    self.movePreviousPeriod = movePreviousPeriod
    self.moveNextPeriod = moveNextPeriod
  }
  
  var body: some View {
    VStack(spacing: 3) {
      Text(periodYearTitle)
        .font(.pretendardMedium_12)
      
      HStack(alignment: .center, spacing: 38) {
        periodNavigationButton(
          direction: .backward,
          isEnabled: canMovePeriod.previous,
          action: movePreviousPeriod
        )
        
        Text(periodTitle)
          .font(.pretendardSemibold_24)
        
        periodNavigationButton(
          direction: .forward,
          isEnabled: canMovePeriod.next,
          action: moveNextPeriod
        )
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 22)
    .padding(.bottom, 15)
    .background(Color.main)
    .foregroundStyle(Color.whiteDefault)
  }
  
  private func periodNavigationButton(
    direction: PeriodNavigationPath,
    isEnabled: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: direction.imageName)
        .font(.custom("SF Pro", size: 16))
        .opacity(isEnabled ? 1 : 0)
    }
    .disabled(!isEnabled)
  }
  
  private enum PeriodNavigationPath {
    case forward, backward
    
    var imageName: String {
      switch self {
      case .forward: return "chevron.right"
      case .backward: return "chevron.left"
      }
    }
  }
}

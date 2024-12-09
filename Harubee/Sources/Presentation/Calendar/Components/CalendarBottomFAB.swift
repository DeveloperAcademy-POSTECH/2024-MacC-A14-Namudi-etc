//
//  ReturnToTodayButton.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/10/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Return To Today Button
struct CalendarBottomFAB: View {
  let title: String
  let titleColor: Color
  let backgroundColor: Color
  let icon: Image?
  let action: () -> Void
  
  var body: some View {
    VStack {
      Spacer()
      Button {
        HapticManager.shared.trigger(.tap)
        action()
      } label: {
        HStack(spacing: 4) {
          icon
            .font(.system(size: 14))
          Text(title)
            .font(.pretendardMedium_14)
        }
        .foregroundColor(titleColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
          Capsule()
            .fill(backgroundColor)
        )
      }
      .padding(.bottom, 14)
      .disabled(icon == nil)
    }
  }
}

//
//  MainColorButton.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct MainColorBottomButton: View {
  
  @Binding private var isEnabled: Bool
  
  private let title: String
  private let isReverseColor: Bool
  private let action: () -> Void
  
  private var foregroundColor: Color {
    !isReverseColor ? .whiteDefault : .main
  }
  
  private var backgroundColor: Color {
    !isReverseColor ? .main : .whiteDefault
  }
  
  init(
    title: String,
    isEnabled: Binding<Bool> = .constant(true),
    isReverseColor: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self._isEnabled = isEnabled
    self.isReverseColor = isReverseColor
    self.action = action
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      HStack {
        Text(title)
          .font(.pretendardSemibold_18)
          .foregroundStyle(
            isEnabled
            ? foregroundColor
            : Color.whiteDeep
          )
          .padding(.vertical, 20)
      }
      .frame(maxWidth: .infinity)
      .background(
        isEnabled
        ? backgroundColor
        : Color.main30
      )
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .padding(.horizontal, 16)
      .padding(.bottom, 9)
    }
    .disabled(!isEnabled)
    .buttonStyle(
      CustomButtonStyle(
        haptic: title == "저장하기" ? .success : .soft
      )
    )
  }
}

#Preview {
  MainColorBottomButton(title: "X") {
    print("Tapped")
  }
}

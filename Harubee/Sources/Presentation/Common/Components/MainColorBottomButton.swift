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
  private let action: () -> Void
  
  init(
    title: String,
    isEnabled: Binding<Bool> = .constant(true),
    action: @escaping () -> Void
  ) {
    self.title = title
    self._isEnabled = isEnabled
    self.action = action
  }
  
  var body: some View {
    HStack {
      Text(title)
        .font(.pretendardSemibold_18)
        .foregroundStyle(isEnabled ? Color.whiteDefault : Color.whiteDeep)
        .padding(.vertical, 20)
    }
    .frame(maxWidth: .infinity)
    .background(isEnabled ? Color.main : Color.main30)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .tapFeedback(haptic: .none) {
      action()
    }
    .disabled(!isEnabled)
    .padding(.horizontal, 16)
    .padding(.bottom, 9)
  }
}

#Preview {
  MainColorBottomButton(title: "X") {
    print("Tapped")
  }
}

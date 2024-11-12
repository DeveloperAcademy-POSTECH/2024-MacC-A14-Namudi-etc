//
//  MainColorButton.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct MainColorButton: View {
  
  @Binding private var isEnabled: Bool
  
  private let title: String
  private let cornerRadius: CGFloat
  private let action: () -> Void
  
  init(
    title: String,
    isEnabled: Binding<Bool> = .constant(true),
    cornerRadius: CGFloat,
    action: @escaping () -> Void
  ) {
    self.title = title
    self._isEnabled = isEnabled
    self.cornerRadius = cornerRadius
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
    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    .tapFeedback(scale: cornerRadius == 0 ? 1 : 0.95, haptic: .none) {
      action()
    }
    .disabled(!isEnabled)
  }
}

#Preview {
  MainColorButton(title: "X", cornerRadius: 0) {
    print("Tapped")
  }
}

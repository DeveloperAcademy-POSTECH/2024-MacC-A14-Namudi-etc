//
//  ButtonStyle+.swift
//  Harubee
//
//  Created by namdghyun on 12/29/24.
//

import SwiftUI

struct TapFeedbackButtonStyle: ButtonStyle {
  // MARK: - Properties
  var scale: CGFloat = 0.95
  var duration: TimeInterval = 0.1
  var animation: Animation = .spring(response: 0.2, dampingFraction: 0.6)
  var backgroundColor: Color = .clear
  var tappedBackgroundColor: Color = .clear
  var cornerRadius: CGFloat = 8
  var haptic: HapticType = .soft
  
  // MARK: - Make Body
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? scale : 1.0)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(configuration.isPressed ? tappedBackgroundColor : backgroundColor)
      )
      .animation(animation, value: configuration.isPressed)
      .onChange(of: configuration.isPressed) { _, isPressed in
        if isPressed {
          HapticManager.shared.trigger(haptic)
        }
      }
  }
}

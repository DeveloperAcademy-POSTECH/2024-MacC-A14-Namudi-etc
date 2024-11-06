//
//  TapFeedbackModifier.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/7/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Tap Feedback Modifier
struct TapFeedbackModifier: ViewModifier {
  // MARK: - Properties
  @State private var isTapped = false
  
  private let action: () -> Void
  private let config: TapConfig
  
  // MARK: - Initialization
  init(config: TapConfig = .init(), action: @escaping () -> Void) {
    self.config = config
    self.action = action
  }
  
  // MARK: - Body
  func body(content: Content) -> some View {
    content
      .overlay(backgroundOverlay)
      .scaleEffect(isTapped ? config.scale : 1.0)
      .contentShape(Rectangle())
      .onTapGesture(perform: handleTap)
  }
  
  // MARK: - UI Components
  private var backgroundOverlay: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(isTapped ? config.tappedBackgroundColor : config.backgroundColor)
  }
  
  // MARK: - Actions
  private func handleTap() {
    // 탭 시작
    withAnimation(config.animation) {
      isTapped = true
    }
    HapticManager.shared.trigger(config.haptic)
    
    // 탭 종료 및 액션 실행
    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
      withAnimation(config.animation) {
        isTapped = false
      }
      action()
    }
  }
}

// MARK: - Tap Configuration
struct TapConfig {
  let scale: CGFloat
  let duration: TimeInterval
  let animation: Animation
  let backgroundColor: Color
  let tappedBackgroundColor: Color
  let haptic: HapticType
  
  init(
    scale: CGFloat = 0.95,
    duration: TimeInterval = 0.1,
    animation: Animation = .spring(response: 0.2, dampingFraction: 0.6),
    backgroundColor: Color = .clear,
    tappedBackgroundColor: Color = Color.textBright.opacity(0.1),
    haptic: HapticType = .soft
  ) {
    self.scale = scale
    self.duration = duration
    self.animation = animation
    self.backgroundColor = backgroundColor
    self.tappedBackgroundColor = tappedBackgroundColor
    self.haptic = haptic
  }
}

// MARK: - View Extension
extension View {
  func tapFeedback(
    scale: CGFloat = 0.95,
    duration: TimeInterval = 0.1,
    animation: Animation = .spring(response: 0.2, dampingFraction: 0.6),
    backgroundColor: Color = .clear,
    tappedBackgroundColor: Color = Color.textBright.opacity(0.1),
    haptic: HapticType = .tap,
    action: @escaping () -> Void
  ) -> some View {
    modifier(
      TapFeedbackModifier(
        config: TapConfig(
          scale: scale,
          duration: duration,
          animation: animation,
          backgroundColor: backgroundColor,
          tappedBackgroundColor: tappedBackgroundColor,
          haptic: haptic
        ),
        action: action
      )
    )
  }
}

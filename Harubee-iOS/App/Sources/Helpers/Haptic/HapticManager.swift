//
//  HapticManager.swift
//  Data
//
//  Created by namdghyun on 11/7/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Haptic Type
enum HapticType {
  case light, medium, heavy, soft, rigid
  case selection
  case success, warning, error
  case tap
  case none
}

// MARK: - Haptic Manager
final class HapticManager {
  // MARK: - Singleton
  static let shared = HapticManager()
  
  private init() {}
  
  // MARK: - Properties
  private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
  private let selectionGenerator = UISelectionFeedbackGenerator()
  private let notificationGenerator = UINotificationFeedbackGenerator()
  
  // MARK: - Methods
  func trigger(_ type: HapticType) {
    switch type {
    case .light, .medium, .heavy, .soft, .rigid:
      triggerImpact(for: type)
    case .selection:
      triggerSelection()
    case .success, .warning, .error:
      triggerNotification(for: type)
    case .tap:
      triggerTap()
    case .none:
      break
    }
  }
  
  private func triggerImpact(for type: HapticType) {
    let style: UIImpactFeedbackGenerator.FeedbackStyle = {
      switch type {
      case .light: return .light
      case .medium: return .medium
      case .heavy: return .heavy
      case .soft: return .soft
      case .rigid: return .rigid
      default: return .medium
      }
    }()
    
    let generator = impactGenerators[style] ?? UIImpactFeedbackGenerator(style: style)
    impactGenerators[style] = generator
    
    generator.prepare()
    generator.impactOccurred()
  }
  
  private func triggerSelection() {
    selectionGenerator.prepare()
    selectionGenerator.selectionChanged()
  }
  
  private func triggerNotification(for type: HapticType) {
    let feedbackType: UINotificationFeedbackGenerator.FeedbackType = {
      switch type {
      case .success: return .success
      case .warning: return .warning
      case .error: return .error
      default: return .success
      }
    }()
    
    notificationGenerator.prepare()
    notificationGenerator.notificationOccurred(feedbackType)
  }
  
  private func triggerTap() {
    let generator = UIImpactFeedbackGenerator(style: .rigid)
    generator.prepare()
    generator.impactOccurred(intensity: 0.4)
  }
}

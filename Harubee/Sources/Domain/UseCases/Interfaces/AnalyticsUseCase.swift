//
//  AnalyticsUseCase.swift
//  Harubee
//
//  Created by namdghyun on 1/18/25.
//

import Foundation

protocol AnalyticsUseCase {
  func trackEvent(event: AnalyticsEvent)
}

enum AnalyticsEvent {
  case buttonTap(name: String)
  case userAction(type: String, content: String)
  
  var name: String {
    switch self {
    case .buttonTap: return "button_tap"
    case .userAction: return "user_action"
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case .buttonTap(let name):
      return ["button_name": name]
    case .userAction(let type, let content):
      return ["action_type": type, "content": content]
    }
  }
}

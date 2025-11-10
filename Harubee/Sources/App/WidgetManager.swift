//
//  WidgetManager.swift
//  Harubee
//
//  Created by 이정동 on 11/10/25.
//

import Foundation
import WidgetKit

@Observable
final class WidgetManager {
  static let shared = WidgetManager()
  
  private init() {}
  
  private(set) var isReloadEnabled: Bool = false
  
  func enableReload() {
    isReloadEnabled = true
  }
  
  func reloadTimeline() {
    WidgetCenter.shared.reloadAllTimelines()
    isReloadEnabled = false
  }
}

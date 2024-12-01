//
//  RootViewManager.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/11/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

@Observable
final class AppRootManager {
  enum Root {
    case onboarding
    case today
  }
  
  private(set) var root: Root
  
  init() {
    let isOnboarding = UserDefaults.standard.object(forKey: "isOnboarding") as? Bool ?? true
    
    root = isOnboarding ? .onboarding : .today
  }
  
  func changeRootViewToToday() {
    self.root = .today
    UserDefaults.standard.set(false, forKey: "isOnboarding")
  }
  
  func changeRootViewToOnboarding() {
    self.root = .onboarding
    UserDefaults.standard.set(true, forKey: "isOnboarding")
  }
}

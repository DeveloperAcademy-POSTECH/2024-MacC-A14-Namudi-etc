//
//  RootViewManager.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/11/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

@Observable
final class RootViewSwitcher {
  enum Root {
    case onboarding
    case main
  }
  
  private(set) var root: Root
  
  init() {
    let isOnboarding = UserDefaults.standard.object(forKey: "isOnboarding") as? Bool ?? true
    
    root = isOnboarding ? .onboarding : .main
  }
  
  func switchRootView() {
    switch root {
    case .onboarding:
      root = .main
      UserDefaults.standard.set(false, forKey: "isOnboarding")
    case .main:
      root = .onboarding
      UserDefaults.standard.set(true, forKey: "isOnboarding")
    }
  }
}

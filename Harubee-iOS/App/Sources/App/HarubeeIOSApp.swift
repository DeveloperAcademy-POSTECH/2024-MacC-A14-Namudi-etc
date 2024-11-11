//
//  HarubeeIOSApp.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

@main
struct HarubeeIOSApp: App {
  
  @State private var appRootManager = AppRootManager()
  
  init() {
    Font.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        switch appRootManager.root {
        case .onboarding:
          Onboarding1View(viewModel: DIContainer.shared.makeOnboardingViewModel())
        case .today:
          TodayView(todayViewModel: DIContainer.shared.makeTodayViewModel())
        }
      }
      .id(appRootManager.root)
      .environment(appRootManager)
    }
  }
}

//
//  HarubeeApp.swift
//  Harubee
//
//  Created by 이정동 on 11/20/24.
//

import SwiftUI

@main
struct HarubeeApp: App {
  @State private var appRootManager = AppRootManager()
  
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

//
//  HarubeeApp.swift
//  Harubee
//
//  Created by 이정동 on 11/20/24.
//

import SwiftUI
import WidgetKit

@main
struct HarubeeApp: App {
  @Environment(\.scenePhase) private var scenePhase
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
      .onChange(of: scenePhase) {
        if case ScenePhase.background = $1 {
          WidgetCenter.shared.reloadAllTimelines()
        }
      }
      .id(appRootManager.root)
      .environment(appRootManager)
    }
  }
}

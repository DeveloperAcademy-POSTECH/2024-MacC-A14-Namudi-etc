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
            .onChange(of: scenePhase) {
              switch $1 {
              case .active:
                print("Active")
              case .inactive:
                print("Inactive")
              case .background:
                print("Background")
                WidgetCenter.shared.reloadAllTimelines()
              @unknown default:
                break
              }
            }
        }
      }
      .id(appRootManager.root)
      .environment(appRootManager)
    }
  }
}

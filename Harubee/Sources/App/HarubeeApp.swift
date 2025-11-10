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
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @Environment(\.scenePhase) private var scenePhase
  
  private var shouldReloadWidget: Bool {
    WidgetManager.shared.isReloadEnabled
  }
  
  var body: some Scene {
    WindowGroup {
      CoordinatorView()
        .onChange(of: scenePhase) {
          if case ScenePhase.background = $1,
             shouldReloadWidget {
            WidgetManager.shared.reloadTimeline()
          }
        }
    }
  }
}

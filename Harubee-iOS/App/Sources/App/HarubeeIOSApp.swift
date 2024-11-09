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
  
  @AppStorage("isOnboarding") private var isOnboarding: Bool = true
  
  init() {
    Font.registerFont()
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    
    appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.whiteDefault)]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.whiteDefault)]
    appearance.backgroundColor = UIColor(Color.main)
    appearance.shadowColor = .clear
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        NavigationStack {
          Onboarding1View()
        }
        .environment(DIContainer.shared.makeOnboardingViewModel())
      } else {
        NavigationStack {
          TodayView(todayViewModel: DIContainer.shared.makeTodayViewModel())
        }
      }
    }
  }
}

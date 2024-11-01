//
//  HarubeeIOSApp.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

@main
struct HarubeeIOSApp: App {
  
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
      ContentView()
    }
  }
}

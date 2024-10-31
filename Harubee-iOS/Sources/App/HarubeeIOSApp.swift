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
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

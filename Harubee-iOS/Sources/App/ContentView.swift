//
//  ContentView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem
import Lottie

struct ContentView: View {
  var body: some View {
    ZStack {
      Color.main
        .ignoresSafeArea()
      
      LottieView(animation: .named(
        LottieConstants.onboarding,
        bundle: LottieConstants.bundle
      ))
      .playing()
    }
  }
}

#Preview {
  ContentView()
}

//
//  Onboarding1View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Lottie

struct Onboarding1View: View {
    var body: some View {
      ZStack {
        Color.main.ignoresSafeArea()
        LottieView(animation: .named("OnboardingAppName"))
          .playing(loopMode: .loop)
          .frame(width: 200, height: 200)
      }
    }
}

#Preview {
    Onboarding1View()
}

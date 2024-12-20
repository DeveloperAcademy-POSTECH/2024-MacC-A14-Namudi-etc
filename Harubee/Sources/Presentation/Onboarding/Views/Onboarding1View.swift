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
  @Environment(OnboardingCoordinator.self) private var coordinator
  @Environment(OnboardingViewModel.self) private var viewModel
  @State private var isVisible: Bool = false
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Color.main.ignoresSafeArea()
      
      VStack {
        LottieView(animation: .onboarding)
          .playing(loopMode: .loop)
          .frame(height: 146)
        Text("쉽고 빠른 지출 계획의 시작")
          .font(.pretendardSemibold_20)
          .foregroundStyle(Color.whiteDefault)
          .offset(y: -30)
      }
      .frame(maxHeight: .infinity)
      .padding(.bottom, 100)
      
      Text(isVisible ? "화면을 터치해주세요" : " ")
        .padding(.bottom, 50)
        .font(.pretendardSemibold_16)
        .foregroundStyle(.whiteDefault)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation {
          self.isVisible = true
        }
      }
    }
    .onTapGesture {
      if isVisible {
        coordinator.push(.onboarding2)
      }
    }
  }
}

#Preview {
  Onboarding1View()
    .environment(DIContainer.shared.makeOnboardingViewModel())
    .environment(OnboardingCoordinator())
}

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
  @State private var viewModel: OnboardingViewModel
  @State var isPresented: Bool = false
  
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      Color.main.ignoresSafeArea()
      VStack(spacing: 0) {
        ZStack(alignment: .bottom) {
          LottieView(animation: .onboarding)
            .playing(loopMode: .loop)
            .frame(height: 146)
          Text("쉽고 빠른 지출 계획의 시작")
            .font(.pretendardSemibold_20)
            .foregroundStyle(Color.whiteDefault)
            .padding(.bottom, 7)
        }
        .padding(.top, UIScreen.main.bounds.height * 0.28)
        // 피그마에서 Lottie 위로 padding 244, 244 / 852 * 100 = 28.~~~
        
        Spacer()
        
        MainColorBottomButton(title: "시작하기") {
          self.isPresented = true
        }
      }
    }
    .navigationDestination(isPresented: $isPresented) {
      Onboarding2View(viewModel: viewModel)
        .navigationBarBackButtonHidden()
    }
  }
}

#Preview {
  Onboarding1View(viewModel: DIContainer.shared.makeOnboardingViewModel())
}

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
  // TODO: Environment로 전달 받기
  @State var viewModel: OnboardingViewModel
  @State private var isVisible: Bool = false
  @State private var isPresented: Bool = false
  
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
      self.isPresented = isVisible
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

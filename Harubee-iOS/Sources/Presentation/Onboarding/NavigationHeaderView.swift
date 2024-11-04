//
//  NavigationHeaderView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

enum OnboardingPage {
  case first, second, third
  
  var number: Int {
    switch self {
    case .first:
      return 1
    case .second:
      return 2
    case .third:
      return 3
    }
  }
}

struct NavigationHeaderView: View {
  private var onboardingPage: OnboardingPage
  
  init(onboardingPage: OnboardingPage) {
    self.onboardingPage = onboardingPage
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Button {
        print("뒤로가기")
      } label: {
        Image(systemName: "chevron.left")
          .font(Font.system(size: 18, weight: .medium))
          .foregroundStyle(Color.whiteDefault)
      }
      Text("\(onboardingPage.number)/3")
        .font(.pretendardSemibold_22)
        .foregroundStyle(Color.whiteDeep50)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
}

#Preview {
  NavigationHeaderView(onboardingPage: .first)
}

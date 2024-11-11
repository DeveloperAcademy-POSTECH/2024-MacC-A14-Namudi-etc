//
//  NavigationHeaderView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

enum OnboardingPage {
  case first, second, third, last
  
  var title: String {
    switch self {
    case .first:
      return "1/3"
    case .second:
      return "2/3"
    case .third:
      return "3/3"
    case .last:
      return " "
    }
  }
}

struct OnboardingNavigationHeaderView: View {
  @Environment(\.dismiss) private var dismiss
  
  private var onboardingPage: OnboardingPage
  
  init(onboardingPage: OnboardingPage) {
    self.onboardingPage = onboardingPage
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Button {
        self.dismiss()
      } label: {
        Image(systemName: "chevron.left")
          .font(Font.system(size: 18, weight: .medium))
          .foregroundStyle(Color.whiteDefault)
      }
      Spacer()
      Text(onboardingPage.title)
        .font(.pretendardSemibold_22)
        .foregroundStyle(Color.whiteDeep50)
//        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .padding(.top, 30)
  }
}

#Preview {
  OnboardingNavigationHeaderView(onboardingPage: .first)
}

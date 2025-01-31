//
//  WidgetAnnounceView.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/24/24.
//

import SwiftUI

struct WidgetAnnounceText: View {
  
  var body: some View {
    VStack {
      Text("앱을 실행시켜 기본 설정을 완료해 주세요")
        .multilineTextAlignment(.center)
        .font(.pretendardSemibold_14)
        .foregroundStyle(.textPrimary30)
    }
    .padding(16)
  }
}

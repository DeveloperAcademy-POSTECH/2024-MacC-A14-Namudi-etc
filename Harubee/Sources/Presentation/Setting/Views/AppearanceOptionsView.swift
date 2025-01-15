//
//  AppearanceOptionsView.swift
//  Harubee
//
//  Created by 신승재 on 1/15/25.
//

import SwiftUI

struct AppearanceOptionsView: View {
  
  @AppStorage("appearance") var selectedAppearance: AppearanceType = .automatic
  
  var body: some View {
    ZStack {
      Color.bgPrimary.ignoresSafeArea()
      VStack {
        SelectionPickerView(
          options: AppearanceType.allCases,
          selectedOption: $selectedAppearance,
          optionFormatter: { "\($0.name) 테마" }
        )
      }
    }
    .navigationBarStyle(.white(title: "화면 테마 설정", backTitle: "뒤로"))
  }
}

#Preview {
  AppearanceOptionsView()
}

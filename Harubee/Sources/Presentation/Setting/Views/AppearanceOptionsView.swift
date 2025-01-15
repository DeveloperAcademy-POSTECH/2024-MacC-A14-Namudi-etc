//
//  AppearanceOptionsView.swift
//  Harubee
//
//  Created by 신승재 on 1/15/25.
//

import SwiftUI

struct AppearanceOptionsView: View {
  
  private let settingViewModel: SettingViewModel
  
  init(settingViewModel: SettingViewModel) {
    self.settingViewModel = settingViewModel
  }
  
  var body: some View {
    ZStack {
      Color.bgPrimary.ignoresSafeArea()
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    .navigationBarStyle(
      .white(title: "언어 설정", backTitle: "뒤로")
    ) {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          
        } label: {
          Text("저장")
            .font(.pretendardMedium_18)
            .foregroundStyle(.mainText)
        }
      }
    }
  }
}

#Preview {
  AppearanceOptionsView(
    settingViewModel: DIContainer.shared.makeSettingViewModel(
    salaryBudget: SalaryBudget.default
  ))
}

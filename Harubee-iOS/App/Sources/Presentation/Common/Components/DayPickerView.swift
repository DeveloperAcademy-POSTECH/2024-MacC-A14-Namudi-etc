//
//  DayPickerStackView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

enum TitleFont {
  case onboarding
  case view
  
  var font: Font {
    switch self {
    case .onboarding:
      return .pretendardMedium_20
    case .view:
      return .pretendardMedium_18
    }
  }
}

struct DayPickerView: View {
  @State private var showDayPicker: Bool = false
  @Binding private var selectedDay: Int
  
  private let title: String
  private let titleFont: TitleFont
  
  init(title: String, titleFont: TitleFont, selectedDay: Binding<Int>) {
    self.title = title
    self.titleFont = titleFont
    self._selectedDay = selectedDay
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text(title)
          .font(titleFont.font)
          .foregroundStyle(Color.textBlack)
        Spacer()
        DayPickerButton(showDayPicker: $showDayPicker, selectedDay: $selectedDay)
      }
      .padding(.horizontal, 20)
      
      if showDayPicker {
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 14)
          .padding(.horizontal, 16)
        
        Picker("날짜 선택", selection: $selectedDay) {
          ForEach(1..<32) { day in
            Text("\(day)일").tag(day)
          }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: .infinity, maxHeight: 150)
        .padding(.horizontal, 10)
        .padding(.top, 21)
        .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .top)))
      }
    }
  }
}

private struct DayPickerButton: View {
  @Binding var showDayPicker: Bool
  @Binding var selectedDay: Int
  var body: some View {
    Button {
      withAnimation(.bouncy) {
        showDayPicker.toggle()
      }
    } label: {
      Text("매달 \(selectedDay)일")
        .font(.pretendardMedium_16)
        .foregroundStyle(showDayPicker ? Color.main : Color.textBlack)
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(Color.textBrighter30)
        )
    }
  }
}

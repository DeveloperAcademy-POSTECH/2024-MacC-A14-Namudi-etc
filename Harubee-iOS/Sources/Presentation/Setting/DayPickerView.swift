//
//  DayPickerStackView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct DayPickerView: View {
  
  @State private var showDayPicker: Bool = false
  @Binding var selectedDay: Int
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("날짜")
          .font(.pretendardMedium_18)
          .foregroundStyle(Color.textBlack)
        Spacer()
        DayPickerButton(showDayPicker: $showDayPicker, selectedDay: $selectedDay)
      }
      .padding(.horizontal, 16)
      
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
      }
    }
  }
}

private struct DayPickerButton: View {
  @Binding var showDayPicker: Bool
  @Binding var selectedDay: Int
  var body: some View {
    Button {
      showDayPicker.toggle()
    } label: {
      Text("매달 \(selectedDay)일")
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.textBlack)
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(Color.textBrighter30)
        )
    }
  }
}

#Preview {
  DayPickerView()
}

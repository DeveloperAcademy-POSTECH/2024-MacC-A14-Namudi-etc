//
//  DayPickerStackView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct DayPickerView: View {
  
  @State private var showDayPicker: Bool = false
  @State private var selectedDay: Date = Date()
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("날짜")
        Spacer()
        DayPickerButton(showDayPicker: $showDayPicker, selectedDay: $selectedDay)
      }
      .padding(.horizontal, 16)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(.gray)
        .padding(.top, 14)
        .padding(.horizontal, 16)
      
      if showDayPicker {
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
  @Binding var selectedDay: Date
  var body: some View {
    Button {
      showDayPicker.toggle()
    } label: {
      Text("매달 1일")
        .font(.system(size: 16))
        .foregroundStyle(.black)
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(Color.gray)
        )
    }
  }
}

#Preview {
  DayPickerView()
}

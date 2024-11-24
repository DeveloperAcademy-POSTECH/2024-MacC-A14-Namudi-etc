//
//  PickerView.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct TimePickerView: View {
  let title: String
  @Binding var isToggleOn: Bool
  @Binding var selectedTime: Date
  @Binding var showPicker: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        
        Text(title)
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
        
        Spacer()
        
        PickerButton(
          showPicker: $showPicker,
          selectedTime: $selectedTime,
          isToggleOn: $isToggleOn
        )
        
        Toggle("", isOn: $isToggleOn)
          .frame(width: 51, height: 31)
          .padding(.leading, 14)
          .tint(.main)
      }
      .padding(.horizontal, 20)

      if showPicker {
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 14)
          .padding(.horizontal, 16)
  
        DatePicker(
          "시간 선택",
          selection: $selectedTime,
          displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .padding(.horizontal, 10)
        .padding(.top, 21)
        .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .top)))
      }
    }
    .onChange(of: isToggleOn) {
      if !isToggleOn && showPicker {
        showPicker = false
      }
    }
  }
}

private struct PickerButton: View {
  @Binding var showPicker: Bool
  @Binding var selectedTime: Date
  @Binding var isToggleOn: Bool
  
  var body: some View {
    Button {
      withAnimation(.bouncy) {
        showPicker.toggle()
      }
    } label: {
      Text(selectedTime.formattedDateToString(.time_kr))
        .font(.pretendardMedium_16)
        .foregroundStyle(
          isToggleOn ? (showPicker ? Color.main : Color.textBlack)
                     : .textBlack30
        )
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(Color.textBrighter30)
        )
    }.disabled(!isToggleOn)
  }
}

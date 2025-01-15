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
          .foregroundStyle(.textPrimary)
        
        Spacer()
        
        PickerButton(
          showPicker: $showPicker,
          selectedTime: $selectedTime,
          isToggleOn: $isToggleOn
        )
        
        Toggle("", isOn: $isToggleOn)
          .frame(width: 51, height: 31)
          .padding(.leading, 14)
          .toggleStyle(CustomToggleStyle())
      }

      if showPicker {
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(.textTertiary30)
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
        withAnimation {
          showPicker = false
        }
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
          isToggleOn ? (showPicker ? .mainPrimary : .textPrimary)
                     : .textTertiary
        )
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(Color.textTertiary30)
        )
    }.disabled(!isToggleOn)
  }
}

struct CustomToggleStyle: ToggleStyle {
  var onColor: Color = .mainPrimary
  var offColor: Color = .textPrimary10
  var thumbColor: Color = .bgPrimary
  
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      Spacer()
      Button {
        configuration.isOn.toggle()
      } label: {
        RoundedRectangle(cornerRadius: 16, style: .circular)
          .fill(configuration.isOn ? onColor : offColor)
          .frame(width: 50, height: 29)
          .overlay(
            Circle()
              .fill(thumbColor)
              .shadow(radius: 1, x: 0, y: 1)
              .padding(1.5)
              .offset(x: configuration.isOn ? 10 : -10)
              .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
          )
      }
    }
    .padding(.horizontal)
  }
}

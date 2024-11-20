//
//  PickerView.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

enum Category {
  case onboarding
  case view
  case setting
  
  var font: Font {
    switch self {
    case .onboarding:
      return .pretendardMedium_20
    case .view:
      return .pretendardMedium_18
    case .setting:
      return .pretendardSemibold_18
    }
  }
}

struct PickerView: View {
  let category: Category
  let title: String
  @Binding var isToggleOn: Bool
  @Binding var selectedDay: Int
  @Binding var selectedTime: Date
  
  @State private var showPicker: Bool = false
  
  private var pickerId: UUID = .init()
  
  init(
    category: Category,
    title: String,
    isToggleOn: Binding<Bool> = .constant(false),
    selectedDay: Binding<Int> = .constant(1),
    selectedTime: Binding<Date> = .constant(Date())
  ) {
    self.category = category
    self.title = title
    self._isToggleOn = isToggleOn
    self._selectedDay = selectedDay
    self._selectedTime = selectedTime
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text(title)
          .font(category.font)
          .foregroundStyle(Color.textBlack)
        
        Spacer()
        
        PickerButton(
          category: category,
          showPicker: $showPicker,
          selectedDay: $selectedDay,
          selectedTime: $selectedTime
        )
        
        if category == .setting {
          Toggle("", isOn: $isToggleOn)
            .frame(width: 51, height: 31)
            .padding(.leading, 14)
            .tint(.main)
        }
      }
      .padding(.horizontal, 20)

      if showPicker {
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 14)
          .padding(.horizontal, 16)
        
        switch(category) {
        case .onboarding, .view:
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
          
        case .setting:
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
    }
  }
}

private struct PickerButton: View {
  let category: Category
  @Binding var showPicker: Bool
  @Binding var selectedDay: Int
  @Binding var selectedTime: Date
  
  var body: some View {
    Button {
      withAnimation(.bouncy) {
        showPicker.toggle()
      }
    } label: {
      switch category {
      case .onboarding, .view:
        Text("매달 \(selectedDay)일")
          .font(.pretendardMedium_16)
          .foregroundStyle(showPicker ? Color.main : Color.textBlack)
          .padding(.vertical, 6)
          .padding(.horizontal, 11)
          .background(
            RoundedRectangle(cornerRadius: 6)
              .foregroundStyle(Color.textBrighter30)
          )
      case .setting:
        Text(selectedTime.formattedDateToString(.time_kr))
          .font(.pretendardMedium_16)
          .foregroundStyle(showPicker ? Color.main : Color.textBlack)
          .padding(.vertical, 6)
          .padding(.horizontal, 11)
          .background(
            RoundedRectangle(cornerRadius: 6)
              .foregroundStyle(Color.textBrighter30)
          )
      }
    }
  }
}

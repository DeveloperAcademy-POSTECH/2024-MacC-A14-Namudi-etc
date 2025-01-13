//
//  FloatingTitleNumberField.swift
//  Harubee
//
//  Created by 이정동 on 12/7/24.
//

import SwiftUI

struct FloatingTitleNumberField: View {
  
  let title: String
  var textSize: TextSize = .medium
  @Binding var text: String
  @Binding var isFocused: Bool
  var minimum: MinimumNumber = .none
  
  private var isErrorTextVisible: Bool {
    text.numberFormat ?? 0 < minimum.value
  }
  
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      VStack(alignment: .leading, spacing: 0) {
        floatingTitle
        
        numberTextField
      }
      .frame(maxWidth: .infinity)
      
      if isErrorTextVisible {
        errorText
          .offset(y: 16)
      }
    }
    .contentShape(Rectangle())
  }
  
  private var floatingTitle: some View {
    Text(title)
      .font(.pretendardMedium_12)
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(
        text.isEmpty
        ? .clear
        : (
          isFocused
          ? (isErrorTextVisible ? .warning : .mainText)
          : .textTertiary
        )
      )
      .offset(y: !text.isEmpty ? -2 : 0)
      .animation(.easeOut(duration: 0.2), value: !text.isEmpty)
      .padding(.leading, 4)
  }
  
  private var numberTextField: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(text.isEmpty ? title : text)
        .foregroundStyle(
          !text.isEmpty ? .textPrimary : .textTertiary
        )
        .font(textSize.font)
        .padding(.leading, 4)
      
      Rectangle()
        .frame(height: isFocused ? 2 : 1)
        .foregroundStyle(
          isFocused
          ? (isErrorTextVisible && !text.isEmpty
             ? .warning
             : .mainSecondary)
          : .textTertiary
        )
        .padding(.top, isFocused ? 7 : 8)
    }
  }
  
  private var errorText: some View {
    HStack(spacing: 2) {
      Image(systemName: "exclamationmark.circle")
        .font(.system(size: 12, weight: .regular))
      Text(minimum.title)
        .font(.pretendardSemibold_12)
    }
    .foregroundStyle(
      text.isEmpty
      ? .clear
      : .warning
    )
    .offset(y: !text.isEmpty ? 4 : 0)
    .animation(.easeOut(duration: 0.2), value: !text.isEmpty)
    .padding(.leading, 4)
  }
}


extension FloatingTitleNumberField {
  enum TextSize {
    case large
    case medium
    
    var font: Font {
      switch self {
      case .large: .pretendardSemibold_28
      case .medium: .pretendardMedium_18
      }
    }
  }
  
  enum MinimumNumber {
    case minimumZero
    case overZero
    case none
    
    var value: Int {
      switch self {
      case .minimumZero: 0
      case .overZero: 1
      case .none: Int.min
      }
    }
    
    var title: String {
      switch self {
      case .minimumZero: "0 이상의 금액을 입력해 주세요"
      case .overZero: "0보다 큰 금액을 입력해 주세요"
      case .none: ""
      }
    }
  }
}


#Preview {
  @Previewable @State var text = ""
  @Previewable @State var isFocused = false
  
  FloatingTitleNumberField(
    title: "Test",
    textSize: .medium,
    text: $text,
    isFocused: $isFocused,
    minimum: .overZero
  )
  .onTapGesture {
    isFocused = true
  }
}

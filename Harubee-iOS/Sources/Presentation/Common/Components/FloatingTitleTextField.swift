//
//  FloatingTitleTextField.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FloatingTitleTextField: View {
  private var title: String
  private var shouldShowKeyboard: Bool
  
  @Binding var text: String
  @FocusState private var isTextfieldFocused: Bool
  
  init(title: String, text: Binding<String>, shouldShowKeyboard: Bool = false) {
    self.title = title
    self._text = text
    self.shouldShowKeyboard = shouldShowKeyboard
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(title)
        .font(.pretendardMedium_12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(!text.isEmpty ? Color.main : .clear)
        .offset(y: !text.isEmpty ? -4 : 0)
        .animation(.easeOut(duration: 0.2), value: !text.isEmpty)
        .padding(.leading, 4)
      
      TextField(title, text: $text)
        .frame(maxWidth: .infinity)
        .font(.pretendardMedium_18)
        .focused($isTextfieldFocused)
        .padding(.leading, 4)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(!text.isEmpty ? Color.main : Color.textBrighter)
        .padding(.top, 8)
    }
    .onAppear {
        self.isTextfieldFocused = shouldShowKeyboard
    }
  }
}

struct FloatingTitleNumberField: View {
  
  enum TextSize {
    case large
    case medium
  }
  
  let title: String
  let textSize: TextSize
  @Binding var text: String
  @Binding var isFocused: Bool
  
  private var textFont: Font {
    if textSize == .large {
      .pretendardSemibold_28
    } else {
      .pretendardMedium_18
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(title)
        .font(.pretendardMedium_12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(
          text.isEmpty
          ? .clear
          : (isFocused ? .main : .textBright)
        )
        .offset(y: !text.isEmpty ? -2 : 0)
        .animation(.easeOut(duration: 0.2), value: !text.isEmpty)
        .padding(.leading, 4)
      
      Text(text.isEmpty ? title : text)
        .foregroundStyle(
          !text.isEmpty ? .textBlack : .textBrighter
        )
        .font(textFont)
        .padding(.leading, 4)
      
      Rectangle()
        .frame(height: isFocused ? 2 : 1)
        .foregroundStyle(
          isFocused ? .main : .textBrighter
        )
        .padding(.top, isFocused ? 7 : 8)
    }
    .frame(maxWidth: .infinity)
    .contentShape(Rectangle())
  }
}

#Preview {
  @Previewable @State var text = ""
  @Previewable @State var isFocused = false
  
  VStack {
    Spacer()
    FloatingTitleTextField(title: "Title", text: $text)
    FloatingTitleNumberField(
      title: "Test",
      textSize: .medium,
      text: $text,
      isFocused: $isFocused
    )
      .onTapGesture {
        isFocused = true
      }
    Spacer()
  }
  .contentShape(Rectangle())
  .onTapGesture {
    isFocused = false
  }
  
}

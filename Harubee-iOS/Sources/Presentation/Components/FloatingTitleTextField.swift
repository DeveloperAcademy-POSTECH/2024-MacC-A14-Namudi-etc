//
//  FloatingTitleTextField.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FloatingTitleTextField: View {
  private var title: String
  @Binding var text: String
  @State private var shouldShowKeyboard: Bool
  @State private var isFocused: Bool = false
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
        .foregroundStyle(isFocused || !text.isEmpty ? Color.main : .clear)
        .offset(y: isFocused || !text.isEmpty ? -4 : 0)
        .animation(.easeOut(duration: 0.2), value: isFocused || !text.isEmpty)
      TextField(title, text: $text)
        .frame(maxWidth: .infinity)
        .font(.pretendardMedium_18)
        .focused($isTextfieldFocused)
        .onAppear {
          if shouldShowKeyboard {
            isTextfieldFocused = true
          }
        }
        .onChange(of: shouldShowKeyboard) { _, newValue in
          isTextfieldFocused = newValue
        }
        .onChange(of: isTextfieldFocused) { _, isFocused in
          if shouldShowKeyboard && !isFocused {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              isTextfieldFocused = true
            }
          }
        }
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter)
      // textfield 작성중일 때 Main
        .padding(.top, 8)
    }
    .padding(.horizontal, 16)
  }
}

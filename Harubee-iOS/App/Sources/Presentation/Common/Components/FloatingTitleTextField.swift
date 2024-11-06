//
//  FloatingTitleTextField.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

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
      
      TextField(title, text: $text)
        .frame(maxWidth: .infinity)
        .font(.pretendardMedium_18)
        .focused($isTextfieldFocused)
      
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

//
//  FloatingTitleTextField.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FloatingTitleTextField: View {
  var title: String
  var shouldShowKeyboard: Bool = false
  
  @Binding var text: String
  @FocusState private var isTextfieldFocused: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      Text(title)
        .font(.pretendardMedium_12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(
          !text.isEmpty
          ? (isTextfieldFocused ? .main : .textBright)
          : .clear
        )
        .offset(y: !text.isEmpty ? -4 : 0)
        .animation(.easeOut(duration: 0.2), value: !text.isEmpty)
        .padding(.leading, 4)
      
      TextField(title, text: $text)
        .frame(maxWidth: .infinity)
        .font(.pretendardMedium_18)
        .focused($isTextfieldFocused)
        .padding(.leading, 4)
      
      Rectangle()
        .frame(height: !isTextfieldFocused ? 1 : 2)
        .foregroundStyle(
          !isTextfieldFocused
          ? .textBrighter
          : .mainBright
        )
        .padding(.top, !isTextfieldFocused ? 8 : 7)
    }
    .onAppear {
        self.isTextfieldFocused = shouldShowKeyboard
    }
    .contentShape(Rectangle())
  }
}


#Preview {
  @Previewable @State var text = ""
  FloatingTitleTextField(title: "Title", text: $text)
}

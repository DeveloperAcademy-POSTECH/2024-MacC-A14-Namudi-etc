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
  @Binding var text: String
  @State private var isFocused: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      Text(title)
        .font(.system(size: 12))
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(isFocused || !text.isEmpty ? .black : .clear)
        .offset(y: isFocused || !text.isEmpty ? -4 : 0)
        .animation(.easeOut(duration: 0.2), value: isFocused || !text.isEmpty)
      TextField(title, text: $text)
        .frame(maxWidth: .infinity)
        .font(.system(size: 16))
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.gray)
        .padding(.top, 8)
    }
    .padding(.horizontal, 16)
  }
}

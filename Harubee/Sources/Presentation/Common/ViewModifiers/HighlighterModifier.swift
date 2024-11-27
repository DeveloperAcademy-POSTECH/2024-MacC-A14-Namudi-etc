//
//  HighlighterModifier.swift
//  Harubee
//
//  Created by 이정동 on 11/27/24.
//

import SwiftUI

struct HighlighterModifier: ViewModifier {
  
  let color: Color
  
  func body(content: Content) -> some View {
    content
      .overlay {
        GeometryReader { proxy in
          Rectangle()
            .fill(color)
            .frame(
              width: proxy.size.width,
              height: proxy.size.height / 2,
              alignment: .center
            )
            .offset(y: proxy.size.height / 2 + 2)
        }
        .padding(.horizontal, -2)
      }
  }
}

extension View {
  func highlighter(_ color: Color) -> some View {
    modifier(HighlighterModifier(color: color))
  }
}

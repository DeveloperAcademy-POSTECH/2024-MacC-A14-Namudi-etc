//
//  infoBubble.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct InfoBubble<Label: View>: ViewModifier {
  
  @State private var contentSize: CGSize = .zero
  @State private var labelSize: CGSize = .zero
  
  private var isVisible: Bool
  private var alignment: Alignment
  private var isOnBottom: Bool
  private var label: () -> Label
  
  private let spacing = 30.0
  
  init(isVisible: Bool,
       alignment: Alignment,
       isOnBottom: Bool,
       @ViewBuilder label: @escaping () -> Label) {
    self.isVisible = isVisible
    self.alignment = alignment
    self.isOnBottom = isOnBottom
    self.label = label
  }
  
  func body(content: Content) -> some View {
    if isVisible {
      content
        .background(
          GeometryReader { contentProxy in
            Color.clear.preference(key: ContentSizeKey.self,
                                   value: CGSize(width: contentProxy.size.width,
                                                 height: contentProxy.size.height))
          }
        )
        .onPreferenceChange(ContentSizeKey.self) { newSize in
          contentSize = newSize
        }
        .overlay(
          VStack(spacing: 0) {
            label()
              .fixedSize()
              .padding(10)
              .background(
                GeometryReader { labelProxy in
                  Color.clear.preference(key: LabelSizeKey.self,
                                         value: CGSize(width: labelProxy.size.width,
                                                       height: labelProxy.size.height))
                }
              )
              .onPreferenceChange(LabelSizeKey.self) { newSize in
                labelSize = newSize
              }
          }
          .background(Color.whiteDefault)
          .cornerRadius(8)
          .offset(calculateOffset())
        )
        .overlay(
          Image(systemName: "triangle.fill")
            .resizable()
            .frame(width: 20, height: 14)
            .rotationEffect(.degrees(isOnBottom ? 0 : 180))
            .foregroundStyle(Color.whiteDefault)
            .offset(y: isOnBottom ? (contentSize.height + spacing) / 2 : -(contentSize.height + spacing) / 2)
        )
    } else { content }
  }
  
  private func calculateOffset() -> CGSize {
    let xOffset: CGFloat
    let yOffset: CGFloat
    
    switch alignment {
    case .leading:
      xOffset = -(contentSize.width - labelSize.width) / 2
    case .trailing:
      xOffset = (contentSize.width - labelSize.width) / 2
    default:
      xOffset = 0
    }
    
    yOffset = isOnBottom ? (contentSize.height + labelSize.height + spacing) / 2 : -(labelSize.height + contentSize.height + spacing) / 2
    
    return CGSize(width: xOffset, height: yOffset)
  }
}

extension View {
  public func infoBubble<Label: View>(isVisible: Bool,
                                      alignment: Alignment = .center,
                                      isOnBottom: Bool = false,
                                      @ViewBuilder label: @escaping () -> Label) -> some View {
    modifier(InfoBubble(isVisible: isVisible, alignment: alignment, isOnBottom: isOnBottom, label: label))
  }
}

struct LabelSizeKey: PreferenceKey {
  static var defaultValue: CGSize { .zero }
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct ContentSizeKey: PreferenceKey {
  static var defaultValue: CGSize { .zero }
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

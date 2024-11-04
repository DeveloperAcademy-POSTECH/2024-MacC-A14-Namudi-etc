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
  
  @Binding private var isVisible: Bool
  private var alignment: Alignment
  private var label: () -> Label
  
  private let spacing:CGFloat = 15.0
  
  init(isVisible: Binding<Bool>,
       alignment: Alignment,
       @ViewBuilder label: @escaping () -> Label) {
    self._isVisible = isVisible
    self.alignment = alignment
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
            .rotationEffect(.degrees([.bottom, .bottomLeading, .bottomTrailing].contains(alignment) ? 0 : 180))
            .foregroundStyle(Color.whiteDefault)
            .offset(y: [.bottom, .bottomLeading, .bottomTrailing].contains(alignment) ? contentSize.height / 2 + spacing : -contentSize.height / 2 - spacing)
        )
    } else { content }
  }
  
  private func calculateOffset() -> CGSize {
    let xOffset: CGFloat = {
      switch alignment {
      case .topLeading, .bottomLeading:
        return -(contentSize.width - labelSize.width) / 2
      case .topTrailing, .bottomTrailing:
        return (contentSize.width - labelSize.width) / 2
      default:
        return 0
      }
    }()
    
    let yOffset: CGFloat = {
      switch alignment {
      case .bottom, .bottomLeading, .bottomTrailing:
        return (contentSize.height + labelSize.height) / 2 + spacing
      default:
        return -(labelSize.height + contentSize.height) / 2 - spacing
      }
    }()
    
    return CGSize(width: xOffset, height: yOffset)
  }
}


extension View {
  public func infoBubble<Label: View>(isVisible: Binding<Bool>,
                                      alignment: Alignment = .center,
                                      @ViewBuilder label: @escaping () -> Label) -> some View {
    modifier(InfoBubble(isVisible: isVisible, alignment: alignment, label: label))
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

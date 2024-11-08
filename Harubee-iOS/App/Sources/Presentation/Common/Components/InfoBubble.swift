//
//  infoBubble.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct InfoBubble<Label: View>: ViewModifier {

  @State private var contentSize: CGSize = .zero
  @State private var labelSize: CGSize = .zero

  @Binding private var isVisible: Bool
  private var alignment: Alignment
  private var label: () -> Label

  private let spacing: CGFloat = 15.0

  init(isVisible: Binding<Bool>,
       alignment: Alignment,
       @ViewBuilder label: @escaping () -> Label) {
    self._isVisible = isVisible
    self.alignment = alignment
    self.label = label
  }

  func body(content: Content) -> some View {
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
            .background(
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.whiteDefault)
                .shadow(color: Color.textBlack.opacity(0.2), radius: 12, x: 2, y: 4)
            )
            .onPreferenceChange(LabelSizeKey.self) { newSize in
              labelSize = newSize
            }
        }
          .offset(calculateOffset())
          .opacity(isVisible ? 1 : 0)
          .scaleEffect(isVisible ? 1 : 0)
          .animation(.spring(duration: 0.2), value: isVisible)
      )
      .overlay(
        Image(systemName: "triangle.fill")
          .resizable()
          .frame(width: 20, height: 14)
          .rotationEffect(.degrees([.bottom, .bottomLeading, .bottomTrailing].contains(alignment) ? 0 : 180))
          .foregroundStyle(Color.whiteDefault)
          .offset(y: [.bottom, .bottomLeading, .bottomTrailing].contains(alignment) ? contentSize.height / 2 + spacing : -contentSize.height / 2 - spacing)
          .opacity(isVisible ? 1 : 0)
          .scaleEffect(isVisible ? 1 : 0)
          .animation(.spring(duration: 0.2), value: isVisible)
          .mask(
            Rectangle()
              .frame(height: 12)
              .offset(y: [.bottom, .bottomLeading, .bottomTrailing].contains(alignment) ? contentSize.height / 2 + spacing - 6 : -contentSize.height / 2 - spacing + 6)
          )
      )
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

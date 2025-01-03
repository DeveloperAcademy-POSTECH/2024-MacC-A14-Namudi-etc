//
//  NavigationBarStyleModifier.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/12/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct NavigationBarStyleModifier<ToolbarItems: ToolbarContent>: ViewModifier {
  @Environment(\.dismiss) private var dismiss
  let style: NavigationBarStyle
  let toolbar: () -> ToolbarItems
  
  func body(content: Content) -> some View {
    if case .sheet = style {
      sheetHeader(content)
    } else {
      navigationBar(content)
    }
  }
  
  private func navigationBar(_ content: Content) -> some View {
    UINavigationBar.appearance().tintColor = UIColor(style.tintColor)
    
    return content
      .toolbarBackground(.clear, for: .navigationBar)
      .toolbarColorScheme(style.colorScheme, for: .navigationBar)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(style.title)
            .font(.pretendardSemibold_18)
            .foregroundStyle(style.titleColor)
        }
        
        if (!style.backTitle.isEmpty) || (style == .onboarding) {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              dismiss()
            } label: {
              HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                  .font(.sfPro(size: 17))
                  .fontWeight(.semibold)
                Text(style.backTitle)
                  .font(.pretendardMedium_18)
              }
              .foregroundStyle(style.tintColor)
            }
          }
        }
        
        toolbar()
      }
  }
  
  private func sheetHeader(_ content: Content) -> some View {
    VStack(spacing: 0) {
      ZStack {
        HStack {
          Button {
            dismiss()
          } label: {
            Text(style.backTitle)
              .font(.pretendardMedium_18)
              .foregroundStyle(style.tintColor)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(style.title)
          .font(.pretendardSemibold_18)
          .foregroundStyle(style.titleColor)
      }
      .padding(.horizontal, 16)
      .padding(.top, 20)
      
      content
    }
  }
}

extension View {
  func navigationBarStyle<ToolbarItems: ToolbarContent>(
    _ style: NavigationBarStyle,
    @ToolbarContentBuilder toolbar: @escaping () -> ToolbarItems = {
      ToolbarItem {}
    }
  ) -> some View {
    modifier(NavigationBarStyleModifier(
      style: style,
      toolbar: toolbar
    ))
  }
}

enum NavigationBarStyle: Equatable {
  case onboarding
  case main(title: String, backTitle: String)
  case white(title: String, backTitle: String)
  case sheet(title: String)
  case clear
  
  var tintColor: Color {
    switch self {
    case .onboarding: return .whiteDefault
    case .main: return .whiteDefault
    case .white: return .main
    case .sheet: return .main
    case .clear: return .clear
    }
  }
  
  var titleColor: Color {
    switch self {
    case .onboarding: return .clear
    case .main: return .whiteDefault
    case .white: return .textBlack
    case .sheet: return .textBlack
    case .clear: return .clear
    }
  }
  
  var colorScheme: ColorScheme {
    switch self {
    case .onboarding: return .dark
    case .main: return .dark
    case .white: return .light
    case .sheet: return .light
    case .clear: return .dark
    }
  }
  
  var title: String {
    switch self {
    case .main(let title, _),
        .white(let title, _),
        .sheet(let title):
      return title
    case .onboarding,
        .clear:
      return ""
    }
  }
  
  var backTitle: String {
    switch self {
    case .main(_, let backTitle),
        .white(_, let backTitle):
      return backTitle
    case .sheet:
      return "취소"
    case .onboarding,
        .clear:
      return ""
    }
  }
}

//
//  NavigationBar+.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/7/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

enum NavigationBarStyle {
  case main(title: String, backTitle: String)
  case white(title: String, backTitle: String)
  case clear(title: String, backTitle: String)
  
  var backgroundColor: Color {
    switch self {
    case .main: return .main
    case .white: return .whiteDefault
    case .clear: return .clear
    }
  }
  
  var tintColor: Color {
    switch self {
    case .main: return .whiteDefault
    case .white: return .main
    case .clear: return .clear
    }
  }
  
  var titleColor: Color {
    switch self {
    case .main: return .whiteDefault
    case .white: return .textBlack
    case .clear: return .clear
    }
  }
  
  var colorScheme: ColorScheme {
    switch self {
    case .main: return .dark
    case .white: return .light
    case .clear: return .dark
    }
  }
  
  var title: String {
    switch self {
    case .main(let title, _), .white(let title, _), .clear(let title, _):
      return title
    }
  }
  
  var backTitle: String {
    switch self {
    case .main(_, let backTitle), .white(_, let backTitle), .clear(_, let backTitle):
      return backTitle
    }
  }
}

extension View {
  func navigationBarStyle(_ style: NavigationBarStyle) -> some View {
    modifier(NavigationBarStyleModifier(style: style))
  }
}

struct NavigationBarStyleModifier: ViewModifier {
  let style: NavigationBarStyle
  @Environment(\.dismiss) private var dismiss
  
  func body(content: Content) -> some View {
    UINavigationBar.appearance().tintColor = UIColor(style.tintColor)
    
    return content
      .toolbarBackground(style.backgroundColor, for: .navigationBar)
      .toolbarColorScheme(style.colorScheme, for: .navigationBar)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(style.title)
            .font(.pretendardSemibold_18)
            .foregroundStyle(style.titleColor)
        }
        
        if !style.backTitle.isEmpty {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 4) {
              Image(systemName: "chevron.left")
                .font(.system(size: 17))
              Text(style.backTitle)
                .font(.pretendardMedium_18)
            }
            .foregroundStyle(style.tintColor)
            .tapFeedback(haptic: .none) {
              dismiss()
            }
          }
        }
      }
  }
}

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}



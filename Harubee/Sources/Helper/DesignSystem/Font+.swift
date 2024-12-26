//
//  AppFont.swift
//  DesignSystem
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

extension Font {
  
  private enum Pretendard: String {
    case black = "Pretendard-Black"
    case extraBold = "Pretendard-ExtraBold"
    case bold = "Pretendard-Bold"
    case semiBold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case light = "Pretendard-Light"
    case extraLight = "Pretendard-ExtraLight"
    case thin = "Pretendard-Thin"
    
    func swiftUIFont(size: CGFloat) -> Font {
      return .custom(self.rawValue, size: size)
    }
  }
  
  // MARK: - Pretendard SemiBold
  static let pretendardSemibold_11 = Pretendard.semiBold.swiftUIFont(size: 11)
  static let pretendardSemibold_12 = Pretendard.semiBold.swiftUIFont(size: 12)
  static let pretendardSemibold_14 = Pretendard.semiBold.swiftUIFont(size: 14)
  static let pretendardSemibold_16 = Pretendard.semiBold.swiftUIFont(size: 16)
  static let pretendardSemibold_18 = Pretendard.semiBold.swiftUIFont(size: 18)
  static let pretendardSemibold_20 = Pretendard.semiBold.swiftUIFont(size: 20)
  static let pretendardSemibold_22 = Pretendard.semiBold.swiftUIFont(size: 22)
  static let pretendardSemibold_24 = Pretendard.semiBold.swiftUIFont(size: 24)
  static let pretendardSemibold_28 = Pretendard.semiBold.swiftUIFont(size: 28)
  static let pretendardSemibold_30 = Pretendard.semiBold.swiftUIFont(size: 30)
  static let pretendardSemibold_40 = Pretendard.semiBold.swiftUIFont(size: 40)
  
  
  // MARK: - Pretendard Medium
  static let pretendardMedium_11 = Pretendard.medium.swiftUIFont(size: 11)
  static let pretendardMedium_12 = Pretendard.medium.swiftUIFont(size: 12)
  static let pretendardMedium_14 = Pretendard.medium.swiftUIFont(size: 14)
  static let pretendardMedium_16 = Pretendard.medium.swiftUIFont(size: 16)
  static let pretendardMedium_18 = Pretendard.medium.swiftUIFont(size: 18)
  static let pretendardMedium_20 = Pretendard.medium.swiftUIFont(size: 20)
  static let pretendardMedium_24 = Pretendard.medium.swiftUIFont(size: 24)
  
  // MARK: - Pretendard Regular
  static let pretendardRegular_22 = Pretendard.regular.swiftUIFont(size: 22)
}

extension Font {
  static func sfPro(size: CGFloat) -> Font {
    return .custom("SF Pro", size: size)
  }
}

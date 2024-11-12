//
//  AppFont.swift
//  DesignSystem
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

extension Font {
  enum PretendardWeight: String, CaseIterable {
    case black = "Pretendard-Black"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semiBold = "Pretendard-SemiBold"
    case thin = "Pretendard-Thin"
  }

  // MARK: - Pretendard SemiBold
  static let pretendardSemibold_12 = Font.custom(PretendardWeight.semiBold.rawValue, size: 12)
  static let pretendardSemibold_14 = Font.custom(PretendardWeight.semiBold.rawValue, size: 14)
  static let pretendardSemibold_16 = Font.custom(PretendardWeight.semiBold.rawValue, size: 16)
  static let pretendardSemibold_18 = Font.custom(PretendardWeight.semiBold.rawValue, size: 18)
  static let pretendardSemibold_20 = Font.custom(PretendardWeight.semiBold.rawValue, size: 20)
  static let pretendardSemibold_22 = Font.custom(PretendardWeight.semiBold.rawValue, size: 22)
  static let pretendardSemibold_24 = Font.custom(PretendardWeight.semiBold.rawValue, size: 24)
  static let pretendardSemibold_28 = Font.custom(PretendardWeight.semiBold.rawValue, size: 28)
  static let pretendardSemibold_30 = Font.custom(PretendardWeight.semiBold.rawValue, size: 30)
  static let pretendardSemibold_40 = Font.custom(PretendardWeight.semiBold.rawValue, size: 40)
  
  
  // MARK: - Pretendard Medium
  static let pretendardMedium_11 = Font.custom(PretendardWeight.medium.rawValue, size: 11)
  static let pretendardMedium_12 = Font.custom(PretendardWeight.medium.rawValue, size: 12)
  static let pretendardMedium_14 = Font.custom(PretendardWeight.medium.rawValue, size: 14)
  static let pretendardMedium_16 = Font.custom(PretendardWeight.medium.rawValue, size: 16)
  static let pretendardMedium_18 = Font.custom(PretendardWeight.medium.rawValue, size: 18)
  static let pretendardMedium_20 = Font.custom(PretendardWeight.medium.rawValue, size: 20)
  static let pretendardMedium_24 = Font.custom(PretendardWeight.medium.rawValue, size: 24)
  
  // MARK: - Custom
  static func customFont(weight: PretendardWeight, size: CGFloat) -> Font {
    return Font.custom(weight.rawValue, size: size)
  }
  
  static func registerFont() {
    let bundleIdentifier = "etc.namudi.harubee-shared"
    
    guard let bundle = Bundle(identifier: bundleIdentifier) else {
      print("Failed to find bundle with identifier: \(bundleIdentifier)")
      return
    }
    
    Font.PretendardWeight.allCases.forEach {
      guard let url = bundle.url(forResource: "\($0.rawValue)", withExtension: ".ttf"),
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) else {
        print("fail register font")
        return
      }
    }
  }
}

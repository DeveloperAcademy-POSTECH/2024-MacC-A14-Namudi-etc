//
//  PreferenceKeys.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/12/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

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

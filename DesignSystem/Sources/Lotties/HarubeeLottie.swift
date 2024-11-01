//
//  HarubeeLottie.swift
//  Core
//
//  Created by namdghyun on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Lottie

public struct HarubeeLottie: View {
  public init() {}
  
  public var body: some View {
    LottieView(animation: .named(
      "harugayongbiyong-lottie",
      bundle: Bundle.module
    ))
    .playing()
  }
}

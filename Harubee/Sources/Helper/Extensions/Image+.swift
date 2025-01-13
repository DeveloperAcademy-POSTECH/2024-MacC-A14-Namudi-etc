//
//  Image+.swift
//  Harubee
//
//  Created by 신승재 on 1/13/25.
//

import SwiftUI

extension Image {
  static func dynamicImage(light: ImageResource, dark: ImageResource) -> Image {
    if UITraitCollection.current.userInterfaceStyle == .dark {
      return Image(dark)
    } else {
      return Image(light)
    }
  }
}

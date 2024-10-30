//
//  Wave.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Wave: Shape {
  var xOffset: CGFloat
  var fillPercentage: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let waveHeight: CGFloat = 10.0
    let waveLength: CGFloat = rect.width
    let fillHeight = rect.height * (1.0 - fillPercentage)
    
    path.move(to: CGPoint(x: 0, y: fillHeight))
    
    for x in stride(from: 0, through: waveLength, by: 1) {
      let relativeX = (x + xOffset) / waveLength
      let sine = sin(relativeX * 2 * .pi)
      let y = fillHeight + sine * waveHeight
      path.addLine(to: CGPoint(x: x, y: y))
    }
    
    path.addLine(to: CGPoint(x: rect.width, y: rect.height))
    path.addLine(to: CGPoint(x: 0, y: rect.height))
    path.closeSubpath()
    
    return path
  }
  
  var animatableData: AnimatablePair<CGFloat, CGFloat> {
    get { AnimatablePair(xOffset, fillPercentage) }
    set {
      xOffset = newValue.first
      fillPercentage = newValue.second
    }
  }
}

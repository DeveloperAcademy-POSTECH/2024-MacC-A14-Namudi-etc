//
//  RoundedHexagon.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI


struct RoundedHexagon: Shape {
  
  private let cornerRadius: CGFloat = 20
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let centerX = rect.width / 2
    let centerY = rect.height / 2
    let radius = min(rect.width, rect.height) / 2
    
    var points: [CGPoint] = []
    
    for i in 0..<6 {
        let angle = (CGFloat(i) * (2 * .pi / 6)) - (.pi / 2)
        let x = centerX + radius * cos(angle)
        let y = centerY + radius * sin(angle)
        points.append(CGPoint(x: x, y: y))
    }
    
    path.move(to: CGPoint(x: points[5].x + CGFloat(sqrt(3) * 10), y: points[5].y - 10))
    
    path.addArc(tangent1End: points[0], tangent2End: points[1], radius: cornerRadius)
    path.addArc(tangent1End: points[1], tangent2End: points[2], radius: cornerRadius)
    path.addArc(tangent1End: points[2], tangent2End: points[3], radius: cornerRadius)
    path.addArc(tangent1End: points[3], tangent2End: points[4], radius: cornerRadius)
    path.addArc(tangent1End: points[4], tangent2End: points[5], radius: cornerRadius)
    path.addArc(tangent1End: points[5], tangent2End: points[0], radius: cornerRadius)
    
    path.closeSubpath()
    
    return path
  }
}

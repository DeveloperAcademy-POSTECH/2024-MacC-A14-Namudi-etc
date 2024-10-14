//
//  UIView+.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import Foundation
import UIKit

extension UIView {
    enum CornerType {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        var value: CACornerMask {
            switch self {
            case .topLeft:
                    .layerMinXMinYCorner
            case .topRight:
                    .layerMaxXMinYCorner
            case .bottomLeft:
                    .layerMinXMaxYCorner
            case .bottomRight:
                    .layerMaxXMaxYCorner
            }
        }
    }
    func roundCorners(cornerRadius: CGFloat, maskedCorners: [CornerType]) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        
        let corners = maskedCorners.map { $0.value }
        
        layer.maskedCorners = CACornerMask(corners)
    }
}

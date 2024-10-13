//
//  UITextField+.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/13/24.
//

import Foundation
import UIKit

extension UITextField {
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
}

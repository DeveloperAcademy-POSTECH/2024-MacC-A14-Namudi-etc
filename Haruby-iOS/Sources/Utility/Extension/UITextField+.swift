//
//  UITextField+.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/14/24.
//

import Foundation
import UIKit

extension UITextField {
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}

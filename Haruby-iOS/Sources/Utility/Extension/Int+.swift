//
//  Int+.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import Foundation

extension Int {
    var decimal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let number = formatter.string(from: NSNumber(value: self)) ?? "NA"
        return number
    }
}

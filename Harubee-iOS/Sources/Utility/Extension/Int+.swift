//
//  Int.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

extension Int {
    var decimal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let number = formatter.string(from: NSNumber(value: self)) ?? "NA"
        return number
    }
    
    var decimalWithWon: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let number = formatter.string(from: NSNumber(value: self)) ?? "NA"
        return number + "원"
    }
}

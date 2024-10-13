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
    
    var decimalWithWon: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let number = formatter.string(from: NSNumber(value: self)) ?? "NA"
        return number + "원"
    }

    // 한국식 돈 표기
    func toKoreanCurrencyFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ko_KR")
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
//
//  String+.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import Foundation

extension String {
    var numberFormat: Int? {
        let string = self
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "원", with: "")
        return Int(string)
    }
}

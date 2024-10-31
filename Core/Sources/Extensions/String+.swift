//
//  String.swift
//  Core
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public extension String {
  subscript(index: Int) -> Self {
    get {
      let index = self.index(self.startIndex, offsetBy: index)
      return String(self[index])
    }
  }
  
  var isSingleNumber: Bool {
    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(self)
  }
  
  var numberFormat: Int? {
    let string = self
      .replacingOccurrences(of: ",", with: "")
      .replacingOccurrences(of: "원", with: "")
    return Int(string)
  }
}

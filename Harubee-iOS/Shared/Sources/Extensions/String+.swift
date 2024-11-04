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
  
  /// 해당 문자열이 단일 숫자(한자리 수)인지를 판단합니다. - [Ex. 5 = true, 10 = false]
  var isSingleNumber: Bool {
    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(self)
  }
  
  /// decimal 포멧으로 된 문자열을 정수로 변환해줍니다. - [Ex. 12,300원 -> 12300]
  var numberFormat: Int? {
    let string = self
      .replacingOccurrences(of: ",", with: "")
      .replacingOccurrences(of: "원", with: "")
    return Int(string)
  }
}

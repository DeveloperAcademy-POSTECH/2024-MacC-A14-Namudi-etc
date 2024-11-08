//
//  Int.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public extension Int {
  
  /// 정수를 decimal 형태로 변환해줍니다 - [Ex. 12,300]
  var decimal: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    
    let number = formatter.string(from: NSNumber(value: self)) ?? "NA"
    return number
  }
  
  /// 정수를 decimal 형태로 변환해주고 마지막에 "원"이 추가됩니다 - [Ex. 12,300원]
  var decimalWithWon: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    
    let number = formatter.string(from: NSNumber(value: self)) ?? "NA"
    return number + "원"
  }
  
  
  func convertDateBetweenStartAndEnd(start: Date, end: Date) -> Date {
    let calendar = Calendar.current
    
    var startDateComponents = calendar.dateComponents([.year, .month, .day], from: start)
    let endDateComponents = calendar.dateComponents([.year, .month, .day], from: end)
    
    while startDateComponents != endDateComponents {
      let day = startDateComponents.day!
      if day == self {
        return calendar.date(from: startDateComponents)!
      }
      startDateComponents.day! += 1
      
      let start = calendar.date(from: startDateComponents)!
      startDateComponents = calendar.dateComponents([.year, .month, .day], from: start)
    }
    
    return calendar.date(from: endDateComponents)!
  }
}

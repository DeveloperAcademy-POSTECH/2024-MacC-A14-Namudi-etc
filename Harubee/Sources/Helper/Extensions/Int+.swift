//
//  Int.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

extension Int {
  
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
  
  /// 정수를 "만원" 단위로 변환해줍니다 - [Ex. 1.2만원]
   var formattedAsTenThousandWon: String {
     let amountInTenThousands = self / 10000
     return String(format: "%d만", amountInTenThousands)
   }
  
  var amountFormat: String {
    if self >= 100000 || self <= -100000{
      return String(format: "%d만", self / 10000)
    } else {
      return self.decimal
    }
  }
  
  func convertDateBetweenStartAndEnd(start: Date, end: Date) -> Date {
    let calendar = Calendar.current
    
    var current = start
    
    while current <= end {
      let day = current.day
      
      if day == self { return current }
      
      current.addTimeInterval(86400)
    }
    
    // 해당 날짜가 기간 사이에 존재하지 않는 경우는 시작 날짜의 달의 마지막 날을 리턴
    let dateComponents = calendar.dateComponents([.year, .month], from: start)
    let date = calendar.date(from: dateComponents)!
    let lastDay = calendar.range(of: .day, in: .month, for: date)!.last!
    
    return Date.create(
      year: dateComponents.year!,
      month: dateComponents.month!,
      day: lastDay
    )
  }
}

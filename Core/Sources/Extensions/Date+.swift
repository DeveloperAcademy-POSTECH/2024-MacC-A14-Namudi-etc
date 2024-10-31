//
//  Date+.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public extension Date {
  
  private var configuredCalendar: Calendar {
    var calendar = Calendar.current
    // 달력 표기 방법 설정
    calendar.locale = .current
    // 타임존 설정
    calendar.timeZone = .current
    return calendar
  }
  
  /// 년도 월 일 (요일) 표기
  var koreanFullDateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
  
  /// Date 값이 어떤 날짜인지를 표현
  var formattedDate: Self {
    let calendar = configuredCalendar
    let dateComponent = calendar.dateComponents([.year, .month, .day], from: self)
    return calendar.date(from: dateComponent)!
  }
}

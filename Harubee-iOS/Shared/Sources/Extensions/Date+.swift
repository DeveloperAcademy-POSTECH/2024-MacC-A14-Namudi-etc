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
  
  /// 년도 월 일 (요일) 표기 - [Ex. 2024년 10월 31일 (목)]
  var koreanFullDateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
  
  /// 일(요일) 표기 - [Ex. 31일 (목)]
  var koreanShortDateString: String {
      let dayFormatter = DateFormatter()
      dayFormatter.dateFormat = "d(EEE)"
      dayFormatter.locale = Locale(identifier: "ko_KR")
      return dayFormatter.string(from: self)
  }
  
  /// 년, 월, 일 값만 사용하기 위한 Date 형식 - [Ex. 2024-10-31 15:00:00 +0000]
  var formattedDate: Self {
    let calendar = configuredCalendar
    let dateComponent = calendar.dateComponents([.year, .month, .day], from: self)
    return calendar.date(from: dateComponent)!
  }
  
  
  /// DateFormat을 변환합니다
  /// - Parameter format: Date에 사용할 DateComponent 타입들
  /// - Returns: Date
  func formattedDate(_ format: Set<Calendar.Component>) -> Self {
    let calendar = configuredCalendar
    let dateComponent = calendar.dateComponents(format, from: self)
    return calendar.date(from: dateComponent)!
  }
  
  /// Date를 String Format으로 변환합니다
  /// - Parameter dateFormatType: 변환하고 싶은 dateFormat 타입
  /// - Returns: 변환된 String 값
  func formattedDateToString(_ dateFormatType: DateFormatType) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormatType.rawValue
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
}

public enum DateFormatType: String {
  case yyyyMMddE = "yyyy년 MM월 dd일 (E)"
  case Md = "M월 d일"
}

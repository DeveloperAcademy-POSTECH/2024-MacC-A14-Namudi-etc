//
// Date+.swift
// Harubee-iOS
//
// Created by 신승재 on 10/30/24.
// Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

extension Date {
  private var configuredCalendar: Calendar {
    var calendar = Calendar.current
    calendar.locale = .current
    calendar.timeZone = .current
    return calendar
  }
  
  /// 캘린더 셀에 표시되는 날짜 텍스트
  /// 1일인 경우 "M/d" 형태로, 나머지는 "d" 형태로 반환
  var calendarDayText: String {
    let day = configuredCalendar.component(.day, from: self)
    let month = configuredCalendar.component(.month, from: self)
    return day == 1 ? "\(month)/\(day)" : "\(day)"
  }
}

// MARK: - Date Operations
extension Date {
  /// 년, 월, 일 값만 사용하기 위한 Date 형식 - [Ex. 2024-10-31 15:00:00 +0000]
  var formattedDate: Date {
    let dateComponent = configuredCalendar.dateComponents([.year, .month, .day], from: self)
    return configuredCalendar.date(from: dateComponent) ?? self
  }
  
  /// 오늘 날짜인지 확인
  var isToday: Bool {
    configuredCalendar.isDateInToday(self)
  }
  
  /// 두 날짜가 같은 날인지 확인
  func isSameDay(as date: Date) -> Bool {
    configuredCalendar.isDate(self, inSameDayAs: date)
  }
  
  /// 연, 월, 일을 지정하여 Date 생성
  static func create(year: Int, month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = 0
    components.minute = 0
    components.second = 0
    
    return Calendar.current.date(from: components)?.formattedDate ?? Date().formattedDate
  }
  
  var day: Int {
    return configuredCalendar.component(.day, from: self)
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


// MARK: - Types
enum DateFormatType: String {
  case fullDate_kr = "yyyy년 MM월 dd일 (E)"
  case year_kr = "yyyy년"
  case monthDay_kr = "M월 d일"
  case monthDay_dot = "M.d"
  case monthDay_slash = "M/d"
  case day_kr = "d일"
  case dayWeekday = "d(EEE)"
}

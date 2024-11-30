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
  
  /// Date를 String Format으로 변환합니다
  /// - Parameter dateFormatType: 변환하고 싶은 dateFormat 타입
  /// - Returns: 변환된 String 값
  func formattedDateToString(_ dateFormatType: DateFormatType) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormatType.rawValue
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
  
  
  // TODO: 수정 필요
  /// 수입일을 기준으로 이번 월급 기간을 계산해줍니다.
  /// - Parameter incomeDay: 수입일
  /// - Returns: 이번 월급 기간의 시작 및 종료 날짜
  static func calculateStartAndEndDate(from incomeDay: Int) -> (Date, Date) {
    var incomeStartDate: Date {
      let calendar = Calendar.current
      let now = Date()
      
      var components = calendar.dateComponents([.year, .month, .day], from: now)
      
      if components.day! < incomeDay {
        components.month! -= 1
      }
      components.day! = incomeDay
      
      let startDate = calendar.date(from: components)!
      return startDate
    }
    
    var incomeEndDate: Date {
      let calendar = Calendar.current
      
      // startDate가 한 달의 시작 날짜가 됩니다.
      let startDate = incomeStartDate
      
      // startDate의 일자(day)를 기준으로 한 달 후의 날짜를 구함
      var components = calendar.dateComponents([.year, .month, .day], from: startDate)
      components.month! += 1 // 한 달 뒤로 설정
      
      // 다음 달에 동일한 일자가 있는지 확인하여 날짜를 생성
      if let calculatedEndDate = calendar.date(from: components) {
        return calculatedEndDate.addingTimeInterval(-86400)
      } else {
        // 동일 일자가 없는 경우(예: 30일이나 31일이 없는 달) 해당 월의 마지막 날로 조정
        var fallbackComponents = components
        fallbackComponents.day = calendar.range(of: .day, in: .month, for: calendar.date(from: components)!)?.last
        return calendar.date(from: fallbackComponents)!
      }
    }
    
    return (incomeStartDate, incomeEndDate)
  }
}


// MARK: - Types
enum DateFormatType: String {
  case fullDate_kr = "yyyy년 MM월 dd일 (E)"
  case year_kr = "yyyy년"
  case monthDay_kr = "M월 d일"
  case monthDay_slash = "M/d"
  case day_kr = "d일"
  case dayWeekday = "d(EEE)"
  case time_kr = "a h:mm"
}

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
    let calendar = Calendar.current
    let today = Date()
    
    var incomeStartDate: Date {
      
      let todayComponents = calendar.dateComponents(
        [.year, .month, .day], from: today
      )
      let currentMonthLastDay = calendar.range(
        of: .day, in: .month, for: today
      )!.upperBound - 1
      
      
      if incomeDay > currentMonthLastDay {
        return create(
          year: todayComponents.year!,
          month: todayComponents.month!,
          day: currentMonthLastDay
        )
        
      } else if incomeDay <= todayComponents.day! {
        return create(
          year: todayComponents.year!,
          month: todayComponents.month!,
          day: incomeDay
        )
      } else {
        let previousMonthFromToday = calendar.date(
          byAdding: .month, value: -1, to: today
        )!
        let previousMonthComponents = calendar.dateComponents(
          [.year, .month, .day], from: previousMonthFromToday
        )
        
        return create(
          year: previousMonthComponents.year!,
          month: previousMonthComponents.month!,
          day: incomeDay
        )
      }
    }
    
    var incomeEndDate: Date {
      let nextMonthFromStartDate = calendar.date(
        byAdding: .month,
        value: 1,
        to: incomeStartDate
      )!
      let nextMonthComponents = calendar.dateComponents(
        [.year, .month, .day], from: nextMonthFromStartDate
      )
      let nextMonthLastDay = calendar.range(
        of: .day, in: .month, for: nextMonthFromStartDate
      )!.upperBound - 1
      let endDay = min(incomeDay, nextMonthLastDay)
      
      return create(
        year: nextMonthComponents.year!,
        month: nextMonthComponents.month!,
        day: endDay
      ).addingTimeInterval(-86400)
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

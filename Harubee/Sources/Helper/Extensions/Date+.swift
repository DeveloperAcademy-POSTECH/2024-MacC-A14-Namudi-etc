//
// Date+.swift
// Harubee-iOS
//
// Created by 신승재 on 10/30/24.
// Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation


// MARK: - Properties
extension Date {
  
  static private let configuredCalendar: Calendar = {
    var calendar = Calendar.current
    calendar.locale = .current
    calendar.timeZone = .current
    return calendar
  }()
  
  /// 년, 월, 일 값만 사용하기 위한 Date 형식 - [Ex. 2024-10-31 15:00:00 +0000]
  var formattedDate: Date {
    let dateComponent = self.getDateComponents([.year, .month, .day])
    return Self.configuredCalendar.date(from: dateComponent) ?? self
  }
  
  /// 오늘 날짜인지 확인
  var isToday: Bool {
    Self.configuredCalendar.isDateInToday(self)
  }
  
  /// Date의 day를 불러옴
  var day: Int {
    return Self.configuredCalendar.component(.day, from: self)
  }
  
  /// 해당 날짜 Month의 마지막 Day를 불러옴
  var lastDayOfMonth: Int {
    Self.configuredCalendar.range(
      of: .day, in: .month, for: self
    )!.upperBound - 1
  }
}



// MARK: - Functions
extension Date {
  
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
  
  /// 특정 날짜까지 남은 일수를 구합니다
  /// - Parameter date: 대상 날짜
  /// - Returns: 남은 일수
  func daysUntil(_ date: Date) -> Int {
    Self.configuredCalendar.dateComponents(
      [.day],
      from: self,
      to: date
    ).day ?? 0
  }
  
  /// Date에서 특정 component에 값을 더합니다.
  /// - Parameters:
  ///   - component: 값을 더할 component
  ///   - value: 더할 값
  /// - Returns: 계산된 Date
  func adding(by component: Calendar.Component, value: Int) -> Date? {
    Self.configuredCalendar.date(
      byAdding: component,
      value: value,
      to: self
    )
  }
  
  /// Date를 String Format으로 변환합니다
  /// - Parameter dateFormatType: 변환하고 싶은 dateFormat 타입
  /// - Returns: 변환된 String 값
  func formattedDateToString(_ dateFormatType: DateFormatType) -> String {
    switch dateFormatType {
    case .emphasizedFirstDay:
      let day = Self.configuredCalendar.component(.day, from: self)
      let month = Self.configuredCalendar.component(.month, from: self)
      return day == 1 ? "\(month)/\(day)" : "\(day)"
    default:
      let formatter = DateFormatter()
      formatter.dateFormat = dateFormatType.rawValue
      formatter.locale = Locale(identifier: "ko_KR")
      return formatter.string(from: self)
    }
  }
  
  /// 두 날짜가 같은 날인지 확인
  func isSameDay(as date: Date) -> Bool {
    Self.configuredCalendar.isDate(self, inSameDayAs: date)
  }
  
  /// 해당 날짜에서 원하는 DateComponent를 반환
  func getDateComponents(
    _ components: Set<Calendar.Component>
  ) -> DateComponents {
    Self.configuredCalendar.dateComponents(
      components, from: self
    )
  }
}


// MARK: - Period Operator
extension Date {
  /// 수입일을 기준으로 이번 월급 기간을 계산해줍니다.
  /// - Parameter incomeDay: 수입일
  /// - Parameter date: 기준 날짜
  /// - Returns: 이번 월급 기간의 시작 및 종료 날짜
  static func calculateStartAndEndDate(
    from incomeDay: Int,
    anchor date: Date
  ) -> (Date, Date) {
    
    let incomeStartDate = calculateStartDate(from: incomeDay, anchor: date)
    let incomeEndDate = calculateEndDate(from: incomeDay, anchor: date)
    
    return (incomeStartDate, incomeEndDate)
  }
  
  /// 특정 날(Day)을 시작, 종료 날짜 사이에 존재하는 날짜로 변환합니다
  /// - Parameters:
  ///   - start: 시작 날짜
  ///   - end: 종료 날짜
  ///   - day: 특정 날(Day)
  /// - Returns: 시작, 종료 날짜 사이의 날짜
  static func convertDateBetweenStartAndEnd(
    start: Date,
    end: Date,
    day: Int
  ) -> Date {
    
    var current = start
    
    while current <= end {
      if current.day == day { return current }
      
      current.addTimeInterval(86400)
    }
    
    // 해당 날짜가 기간 사이에 존재하지 않는 경우는 시작 날짜의 달의 마지막 날을 리턴
    let startComponents = start.getDateComponents([.year, .month])
    let lastDay = start.lastDayOfMonth
    
    return Date.create(
      year: startComponents.year!,
      month: startComponents.month!,
      day: lastDay
    )
  }

  static private func calculateStartDate(
    from incomeDay: Int,
    anchor date: Date
  ) -> Date {
    let date = date.formattedDate
    let dateComponents = date.getDateComponents([.year, .month, .day])
    let lastDayOfMonth = date.lastDayOfMonth
    
    // 전달이 시작 날짜인 경우
    // -> 수입일 <= 기준 날짜의 Day || 기준 날짜의 Day가 마지막 날
    if incomeDay <= dateComponents.day!
        || lastDayOfMonth == dateComponents.day! {
      
      return Date.create(
        year: dateComponents.year!,
        month: dateComponents.month!,
        day: min(incomeDay, lastDayOfMonth)
      )
      
    // 이번달이 시작 날짜인 경우
    // -> 수입일 > 기준 날짜의 Day && 기준 날짜의 Day가 마지막 날이 아님
    } else {
      
      let year = dateComponents.year!
      let month = dateComponents.month!
      let previousDate = Date.create(
        year: month == 1 ? year - 1 : year,
        month: month == 1 ? 12 : month - 1,
        day: 1
      )
      
      let previousComponents = previousDate.getDateComponents([.year, .month, .day])
      let previousLastDayOfMonth = previousDate.lastDayOfMonth
      
      return Date.create(
        year: previousComponents.year!,
        month: previousComponents.month!,
        day: min(previousLastDayOfMonth, incomeDay)
      )
    }
  }

  static private func calculateEndDate(
    from incomeDay: Int,
    anchor date: Date
  ) -> Date {
    let date = date.formattedDate
    let dateComponents = date.getDateComponents([.year, .month, .day])
    let lastDayOfMonth = date.lastDayOfMonth
    
    // 이번달이 종료 날짜인 경우
    // -> 기준 날짜의 Day < 수입일 && 기준 날짜의 Day가 마지막 날이 아님
    if dateComponents.day! < incomeDay
        && dateComponents.day! != lastDayOfMonth {
      
      return Date.create(
        year: dateComponents.year!,
        month: dateComponents.month!,
        day: min(lastDayOfMonth, incomeDay) - 1
      )
      
    // 다음달이 종료 날짜인 경우
    // 기준 날짜의 Day >= 수입일 || 기준 날짜의 Day가 마지막 날
    } else {
      
      let year = dateComponents.year!
      let month = dateComponents.month!
      
      let nextDate = Date.create(
        year: month == 12 ? year + 1 : year,
        month: month == 12 ? 1 : month + 1,
        day: 1
      )
      
      let nextDateComponents = nextDate.getDateComponents([.year, .month, .day])
      let nextLastDayOfMonth = nextDate.lastDayOfMonth
      
      return Date.create(
        year: nextDateComponents.year!,
        month: nextDateComponents.month!,
        day: min(nextLastDayOfMonth, incomeDay) - 1
      )
    }
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
  case emphasizedFirstDay = ""
}

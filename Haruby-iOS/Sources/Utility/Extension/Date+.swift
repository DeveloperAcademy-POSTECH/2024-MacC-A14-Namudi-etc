//
//  Date+.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

extension Date {
    private var configuredCalendar: Calendar {
        var calendar = Calendar.current
        // 달력 표기 방법 설정
        calendar.locale = .current
        // 타임존 설정
        calendar.timeZone = .current
        return calendar
    }
    
    /// Date 값이 어떤 날짜인지를 표현
    var formattedDate: Self {
        let calendar = configuredCalendar
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: dateComponent)!
    }
    
    /// Date 값에서 월 Int만 추출
    var monthValue: Int {
        let calendar = configuredCalendar
        let dateComponent = calendar.dateComponents([.month], from: self)
        return dateComponent.month!
    }
    
    var formattedDateToStringforMainView: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}

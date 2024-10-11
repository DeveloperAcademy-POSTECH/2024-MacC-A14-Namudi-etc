//
//  Date+.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

extension Date {
    /// Date 값이 어떤 날짜인지를 표현
    var formattedDate: Self {
    var calendar = Calendar.current
    
    // 달력 표기 방법 설정
    calendar.locale = .current
    // 타임존(UTC 시간관련된 개념) 설정
    calendar.timeZone = .current
    
    let dateComponent = calendar.dateComponents([.year, .month, .day], from: self)
    
    return calendar.date(from: dateComponent)!
    }
}
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
    
    var formattedDateToStringforMainView: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// Date값을 ~월 String으로 표현
    func formattedMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월"
        return dateFormatter.string(from: self)
}

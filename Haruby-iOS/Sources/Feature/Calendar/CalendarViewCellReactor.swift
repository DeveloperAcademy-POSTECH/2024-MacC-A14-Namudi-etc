//
//  CalendarViewCellReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/10/24.
//

import UIKit

import ReactorKit
import RxSwift

class CalendarViewCellReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var dayNumber: String         // 날짜 숫자 (문자열로 표현)
        var isFirstDayOfMonth: Bool   // 월의 첫 날인지 여부
        var monthName: String         // 월 이름 (월의 첫 날에만 표시)
        var isVisible: Bool           // 셀이 표시 가능한지 여부
        var isHighlighted: Bool       // 강조 표시 여부 (오늘 날짜 또는 선택된 날짜)
        var isCurrentMonth: Bool      // 현재 표시 중인 월의 날짜인지 여부
    }
    
    let initialState: State
    
    init(dayItem: DayItem) {
        let calendar = Calendar.current
        
        let dayNumber: String
        if let date = dayItem.date {
            let dayComponent = calendar.component(.day, from: date)
            if dayComponent == 1 {
                let monthComponent = calendar.component(.month, from: date)
                dayNumber = "\(monthComponent)/\(dayComponent)"
            } else {
                dayNumber = "\(dayComponent)"
            }
        } else {
            dayNumber = ""
        }
        
        // 월의 첫 날인지 확인
        let isFirstDayOfMonth = dayItem.date.map { calendar.component(.day, from: $0) == 1 } ?? false
        
        // 월 이름 설정 (월의 첫 날이고 날짜가 있는 경우에만)
        //let monthName = (isFirstDayOfMonth && dayItem.date != nil) ? dayItem.date!.toString(dateFormat: "MMM") : ""
        let monthName = ""

        // 초기 상태 설정
        initialState = State(
            dayNumber: dayNumber,
            isFirstDayOfMonth: isFirstDayOfMonth,
            monthName: monthName,
            isVisible: dayItem.date != nil,       // 날짜가 있으면 표시 가능
            isHighlighted: dayItem.isToday || dayItem.isSelected,  // 오늘 날짜이거나 선택된 날짜면 강조
            isCurrentMonth: dayItem.isCurrentMonth  // 현재 월의 날짜인지 여부
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        // code
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        // code
    }
    
    // MARK: - Private Methods
}

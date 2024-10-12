//
//  CalendarViewReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/10/24.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift

class CalendarViewReactor: Reactor {
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setMonthSections([MonthSection])
    }
    
    struct State {
        var monthSections: [MonthSection] = []
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .viewDidLoad:
            return Observable.just(Mutation.setMonthSections(generateMonthSections()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMonthSections(let monthSections):
            newState.monthSections = monthSections
        }
        return newState
    }
    
    // MARK: - Private Methods
    private func generateMonthSections() -> [MonthSection] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // 현재 월을 기준으로 전후 12개월의 데이터 생성
        return (-12...12).map { monthOffset in
            guard let monthDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) else {
                fatalError("Failed to create date")
            }
            
            let days = daysInMonth(monthDate)
            return MonthSection(month: monthDate, items: days)
        }
    }
    
    // 특정 월의 일별 데이터를 생성하는 메서드
    private func daysInMonth(_ date: Date) -> [DayItem] {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStart)!
        let monthEnd = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        
        let numberOfDaysInMonth = calendar.component(.day, from: monthEnd)
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        
        var days: [DayItem] = []
        
        // 월의 시작 요일 이전의 빈 날짜 추가
        for _ in 1..<firstWeekday {
            days.append(DayItem(date: nil, isSelectable: false, isToday: false, isSelected: false, isCurrentMonth: false))
        }
        
        let today = calendar.startOfDay(for: Date())
        // 월의 각 날짜에 대한 DayItem 생성
        for day in 1...numberOfDaysInMonth {
            let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart)!
            days.append(DayItem(
                date: date,
                isSelectable: true,
                isToday: calendar.isDate(date, inSameDayAs: today),
                isSelected: false,
                isCurrentMonth: true
            ))
        }
        
        return days
    }
}


struct MonthSection {
    var month: Date // 해당 월의 첫날
    var items: [DayItem]
}

extension MonthSection: SectionModelType {
    init(original: MonthSection, items: [DayItem]) {
        self = original
        self.items = items
    }
}

struct DayItem {
    let date: Date?
    let isSelectable: Bool
    let isToday: Bool
    let isSelected: Bool
    let isCurrentMonth: Bool
}

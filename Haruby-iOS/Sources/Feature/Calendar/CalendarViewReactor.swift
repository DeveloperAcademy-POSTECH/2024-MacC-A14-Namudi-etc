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
        case initializeCalendar
    }
    
    enum Mutation {
        case updateMonthSections([MonthlySection])
    }
    
    struct State {
        var monthlySections: [MonthlySection] = []
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .initializeCalendar:
            return Observable.just(Mutation.updateMonthSections(createMonthSections()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateMonthSections(let monthlySections):
            newState.monthlySections = monthlySections
        }
        return newState
    }
    
    // MARK: - Private Methods
    private func createMonthSections() -> [MonthlySection] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        return (-1...12).map { monthOffset in
            guard let monthDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) else {
                fatalError("Failed to create date")
            }
            
            let days = generateDaysForMonth(monthDate)
            return MonthlySection(firstDayOfMonth: monthDate, items: days)
        }
    }
    
    private func generateDaysForMonth(_ date: Date) -> [DayItem] {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStart)!
        let monthEnd = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        
        let numberOfDaysInMonth = calendar.component(.day, from: monthEnd)
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        
        var days: [DayItem] = []
        
        for _ in 1..<firstWeekday {
            days.append(DayItem(date: nil, isInSalaryPeriod: false, isToday: false, isSelected: false, haruby: nil, memo: nil, expense: nil, income: nil))
        }
        
        let today = calendar.startOfDay(for: Date())
        for day in 1...numberOfDaysInMonth {
            let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart)!
            days.append(DayItem(
                date: date,
                isInSalaryPeriod: true,
                isToday: calendar.isDate(date, inSameDayAs: today),
                isSelected: false,
                haruby: 12000,
                memo: nil,
                expense: nil,
                income: nil
            ))
        }
        
        return days
    }
}


struct MonthlySection {
    var firstDayOfMonth: Date
    var items: [DayItem]
}

extension MonthlySection: SectionModelType {
    init(original: MonthlySection, items: [DayItem]) {
        self = original
        self.items = items
    }
}

struct DayItem {
    var date: Date?
    var isInSalaryPeriod: Bool
    var isToday: Bool
    var isSelected: Bool
    var haruby: Int?
    var memo: String?
    var expense: TransactionRecord?
    var income: TransactionRecord?
}

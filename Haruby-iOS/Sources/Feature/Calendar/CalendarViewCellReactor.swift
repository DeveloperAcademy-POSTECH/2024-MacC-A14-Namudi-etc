//
//  CalendarViewCellReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/10/24.
//

import UIKit

import ReactorKit
import RxSwift

final class CalendarViewCellReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var currentDate: Date = .now
        
        // UI표시
        var dayNumber: String           // 날짜 숫자
        var isVisible: Bool             // 셀이 표시 가능한지 여부
        var showTodayIndicator: Bool    // 오늘 인디케이터를 보여줄지
        var showHiglight: Bool          // 날짜에 하이라이트를 보여줄지
        var showRedDot: Bool
        var showBlueDot: Bool
        var harubyNumber: String?              // 하루비
        var isPastHaruby: Bool
        

    }
    
    let initialState: State
    
    init(dailyBudget: DailyBudget, salaryStartDate: Date, salaryEndDate: Date, defaultHaruby: Int) {
        
        let currentDay = Date()
        let calendar = Calendar.current
        let dayNumber = dailyBudget.date.dayValue
        let monthNumber = dailyBudget.date.monthValue
        
        let isInSalaryPeriod = dailyBudget.date >= salaryStartDate && dailyBudget.date <= salaryEndDate
        let isPastDay = dailyBudget.date < currentDay
        let isExpenseExist = !dailyBudget.expense.transactionItems.isEmpty
        
        var harubyNumber: String?
        if isInSalaryPeriod {
            if isPastDay {
                harubyNumber = isExpenseExist ? dailyBudget.expense.total.decimal : nil
            } else {
                harubyNumber = dailyBudget.haruby?.decimal ?? defaultHaruby.decimal
            }
        } else {
            harubyNumber = nil
        }

        initialState = State(
            dayNumber: dayNumber == 1 ? "\(monthNumber)/\(dayNumber)" : "\(dayNumber)",
            isVisible: dailyBudget.date != Date.distantPast ? true : false,
            showTodayIndicator: calendar.isDate(dailyBudget.date, inSameDayAs: currentDay),
            showHiglight: isInSalaryPeriod,
            showRedDot: !isExpenseExist && isInSalaryPeriod,
            showBlueDot: dailyBudget.haruby != nil,
            harubyNumber: harubyNumber,
            isPastHaruby: isPastDay
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

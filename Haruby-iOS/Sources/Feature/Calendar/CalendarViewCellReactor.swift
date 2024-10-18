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
        case viewDidLoad
        case cellTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var currentDate: Date = .now
        var dailyBudget: DailyBudget?
        
        var viewState: ViewState
        
    }
    
    struct ViewState {
        var dayNumber: String = ""
        var isVisible: Bool = false
        var showTodayIndicator: Bool = false
        var showHiglight: Bool = false
        var showBlueDot: Bool = false
        var showRedXMark: Bool = false
        var harubyNumber: String? = nil
        var isPastHaruby: Bool = false
        var highlightType: CellHighlightType
    }
    
    let initialState: State
    
    init(dailyBudget: DailyBudget, salaryStartDate: Date, salaryEndDate: Date, defaultHaruby: Int, indexPath: IndexPath) {
        
        let currentDay = Date()
        let calendar = Calendar.current
        
        let dayNumber = dailyBudget.date.dayValue
        let monthNumber = dailyBudget.date.monthValue
        let lastDay = calendar.range(of: .day, in: .month, for: dailyBudget.date)?.last

        let isInSalaryPeriod = dailyBudget.date >= salaryStartDate && dailyBudget.date <= salaryEndDate
        let isPastDay = dailyBudget.date < currentDay
        let isExpenseExist = !dailyBudget.expense.transactionItems.isEmpty
        
        var harubyNumber: String?
        
        if isInSalaryPeriod {
            harubyNumber = isPastDay ? (isExpenseExist ? dailyBudget.expense.total.decimal : nil) : (dailyBudget.haruby?.decimal ?? defaultHaruby.decimal)
        }
        
        var highlightType: CellHighlightType = .normal
        
        if dailyBudget.date == salaryStartDate {
            highlightType = .leftRound
        } else if dailyBudget.date == salaryEndDate {
            highlightType = .rightRound
        } else if dayNumber == 1 {
            highlightType = .leftRound
        } else if dayNumber == lastDay {
            highlightType = .rightRound
        } else if indexPath.item % 7 == 0 {
            highlightType = .leftRound
        } else if indexPath.item % 7 == 6 {
            highlightType = .rightRound
        } else {
            highlightType = .normal
        }
        
        let initialViewState = ViewState(
            dayNumber: dayNumber == 1 ? "\(monthNumber)/\(dayNumber)" : "\(dayNumber)",
            isVisible: dailyBudget.date != Date.distantPast,
            showTodayIndicator: calendar.isDate(dailyBudget.date, inSameDayAs: currentDay),
            showHiglight: isInSalaryPeriod,
            showBlueDot: dailyBudget.haruby != nil,
            showRedXMark: isInSalaryPeriod && isPastDay && !isExpenseExist,
            harubyNumber: harubyNumber,
            isPastHaruby: isPastDay,
            highlightType: highlightType
        )
        
        self.initialState = State(dailyBudget: dailyBudget, viewState: initialViewState)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        case .cellTapped:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        // code
    }
    
    
}

enum CellHighlightType {
    case leftRound
    case rightRound
    case normal
}

enum DayType {
    case past
    case today
    case future
    case none
}

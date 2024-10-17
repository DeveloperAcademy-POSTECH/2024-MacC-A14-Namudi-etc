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
        case updateState(State)
    }
    
    struct State {
        var currentDate: Date = .now
        
        var viewState: ViewState
        var dailyBudget: DailyBudget?
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
        
        // 월급 구간안에 있고 과거이면 실제 지출, 미래이면 조정된 하루비, 조정된 하루비가 없으면 기본 하루비
        if isInSalaryPeriod {
            harubyNumber = isPastDay ? (isExpenseExist ? dailyBudget.expense.total.decimal : nil) : (dailyBudget.haruby?.decimal ?? defaultHaruby.decimal)
        }
        
        
        let initialViewState = ViewState(
            dayNumber: dayNumber == 1 ? "\(monthNumber)/\(dayNumber)" : "\(dayNumber)",
            isVisible: dailyBudget.date != Date.distantPast,
            showTodayIndicator: calendar.isDate(dailyBudget.date, inSameDayAs: currentDay),
            showHiglight: isInSalaryPeriod,
            showBlueDot: dailyBudget.haruby != nil,
            showRedXMark: isInSalaryPeriod && isPastDay && !isExpenseExist,
            harubyNumber: harubyNumber,
            isPastHaruby: isPastDay
        )
        
        self.initialState = State(viewState: initialViewState, dailyBudget: dailyBudget)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        // code
        switch action {
        case .viewDidLoad:
            return .empty()
        case .cellTapped:
            print("cellTapped")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateState(let newStateData):
            newState.viewState = newStateData.viewState
            newState.dailyBudget = newStateData.dailyBudget
        }
        return newState
    }
    
    
}

extension CalendarViewCellReactor {
    // MARK: - Private Methods
    /// 하루비와 관련된 상태 계산 로직
    private func calculateViewState(dailyBudget: DailyBudget, salaryStartDate: Date, salaryEndDate: Date, defaultHaruby: Int) -> ViewState {
        let currentDay = Date()
        let calendar = Calendar.current
        
        let dayNumber = dailyBudget.date.dayValue
        let monthNumber = dailyBudget.date.monthValue
        let isInSalaryPeriod = dailyBudget.date >= salaryStartDate && dailyBudget.date <= salaryEndDate
        let isPastDay = dailyBudget.date < currentDay
        let isExpenseExist = !dailyBudget.expense.transactionItems.isEmpty
        
        var harubyNumber: String?
        if isInSalaryPeriod {
            harubyNumber = isPastDay ? (isExpenseExist ? dailyBudget.expense.total.decimal : nil) : (dailyBudget.haruby?.decimal ?? defaultHaruby.decimal)
        }
        
        return ViewState(
            dayNumber: dayNumber == 1 ? "\(monthNumber)/\(dayNumber)" : "\(dayNumber)",
            isVisible: dailyBudget.date != Date.distantPast,
            showTodayIndicator: calendar.isDate(dailyBudget.date, inSameDayAs: currentDay),
            showHiglight: isInSalaryPeriod,
            showBlueDot: dailyBudget.haruby != nil,
            harubyNumber: harubyNumber,
            isPastHaruby: isPastDay
        )
    }
}

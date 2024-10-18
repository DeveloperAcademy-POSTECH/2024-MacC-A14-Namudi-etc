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
        case setNavigate(Bool)
    }
    
    struct State {
        var currentDate: Date = .now
        
        var dayType: DayType
        var dailyBudget: DailyBudget?
        var navigateToNextView: Bool = false
        
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
    let stateSubject = PublishSubject<State>()
    
    init(dailyBudget: DailyBudget, salaryStartDate: Date, salaryEndDate: Date, defaultHaruby: Int, indexPath: IndexPath) {
        
        let calendar = Calendar.current
        let currentDay = calendar.startOfDay(for: Date())
        
        // 날짜 관련 값 계산
        let dayNumber = dailyBudget.date.dayValue
        let monthNumber = dailyBudget.date.monthValue
        let lastDay = calendar.range(of: .day, in: .month, for: dailyBudget.date)?.last
        
        // 상태 계산 함수 호출
        let dayType = Self.determineDayType(for: dailyBudget.date,
                                            salaryStartDate: salaryStartDate,
                                            salaryEndDate: salaryEndDate,
                                            currentDay: currentDay,
                                            calendar: calendar)

        let harubyNumber = Self.calculateHarubyNumber(for: dailyBudget,
                                                      isInSalaryPeriod: dailyBudget.date >= salaryStartDate && dailyBudget.date <= salaryEndDate,
                                                      currentDate: currentDay,
                                                      isPastDay: dayType == .past,
                                                      defaultHaruby: defaultHaruby,
                                                      calendar: calendar)
        
        let highlightType = Self.determineHighlightType(dayNumber: dayNumber,
                                                        lastDay: lastDay,
                                                        salaryStartDate: salaryStartDate,
                                                        salaryEndDate: salaryEndDate,
                                                        indexPath: indexPath)
        
        let initialViewState = ViewState(
            dayNumber: dayNumber == 1 ? "\(monthNumber)/\(dayNumber)" : "\(dayNumber)",
            isVisible: dailyBudget.date != Date.distantPast,
            showTodayIndicator: dayType == .today,
            showHiglight: dayType != .none,
            showBlueDot: dailyBudget.haruby != nil,
            showRedXMark: (dayType == .past || dayType == .today) && dailyBudget.expense.transactionItems.isEmpty,
            harubyNumber: harubyNumber,
            isPastHaruby: dayType == .past,
            highlightType: highlightType
        )
        
        self.initialState = State(dayType: dayType, dailyBudget: dailyBudget, viewState: initialViewState)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        stateSubject.onNext(self.currentState)
        switch action {
        case .viewDidLoad:
            return .empty()
        case .cellTapped:
            let setNavigateTrue = Observable.just(Mutation.setNavigate(true))
            let setNavigateFalse = Observable.just(Mutation.setNavigate(false))

            return Observable.concat([setNavigateTrue, setNavigateFalse])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNavigate(let navigate):
            newState.navigateToNextView = navigate
        }
        return newState
    }
    
    
}

extension CalendarViewCellReactor {
    // DayType을 결정하는 함수
    private static func determineDayType(for date: Date, salaryStartDate: Date, salaryEndDate: Date, currentDay: Date, calendar: Calendar) -> DayType {
        if date >= salaryStartDate && date <= salaryEndDate {
            if date < currentDay {
                return .past
            } else if calendar.isDate(date, inSameDayAs: currentDay) {
                return .today
            } else {
                return .future
            }
        }
        return .none
    }

    // HarubyNumber 계산 함수
    private static func calculateHarubyNumber(for dailyBudget: DailyBudget, isInSalaryPeriod: Bool, currentDate: Date, isPastDay: Bool, defaultHaruby: Int, calendar: Calendar) -> String? {
        guard isInSalaryPeriod else {
            return nil
        }
        
        if isPastDay || calendar.isDate(dailyBudget.date, inSameDayAs: currentDate) {
            // 과거인 경우, 지출이 있으면 지출 총액을 표시, 없으면 nil
            return !dailyBudget.expense.transactionItems.isEmpty ? dailyBudget.expense.total.decimal : nil
        } else {
            // 미래 또는 오늘인 경우, 하루비가 있으면 그 값, 없으면 기본 하루비
            return dailyBudget.haruby?.decimal ?? defaultHaruby.decimal
        }
    }


    private static func determineHighlightType(dayNumber: Int, lastDay: Int?, salaryStartDate: Date, salaryEndDate: Date, indexPath: IndexPath) -> CellHighlightType {
        if dayNumber == 1 || indexPath.item % 7 == 0 || salaryStartDate.dayValue == dayNumber {
            return .leftRound
        } else if lastDay == dayNumber || indexPath.item % 7 == 6 || salaryEndDate.dayValue == dayNumber {
            return .rightRound
        } else {
            return .normal
        }
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

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

final class CalendarViewReactor: Reactor {
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
}


extension CalendarViewReactor {
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
    
    private func generateDaysForMonth(_ date: Date) -> [DailyBudget] {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStart)!
        let monthEnd = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        
        let numberOfDaysInMonth = calendar.component(.day, from: monthEnd)
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        
        var dailyBudgets: [DailyBudget] = []
        
        for _ in 1..<firstWeekday {
            dailyBudgets.append(
                DailyBudget(
                    date: Date.distantPast,
                    haruby: nil,
                    memo: "",
                    expense: TransactionRecord(total: 0, transactionItems: []),
                    income: TransactionRecord(total: 0, transactionItems: [])
                )
            )
        }
        
        for day in 1...numberOfDaysInMonth {
            let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart)!
            // TODO: 데이터 연결시 넣기
            dailyBudgets.append(DailyBudget(
                date: date,
                haruby: 36000,
                memo: "",
                expense: TransactionRecord(total: 0, transactionItems: []),
                income: TransactionRecord(total: 0, transactionItems: [])
            ))
        }
        
        return dailyBudgets
    }
}


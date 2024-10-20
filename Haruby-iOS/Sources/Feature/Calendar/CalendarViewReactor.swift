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
        case viewDidLoad
        case scrollCalendar(Int)
    }
    
    enum Mutation {
        case setSalaryBudget(SalaryBudget)
        case updateMonthSections([MonthlySection])
        case setFocusedSection(Int)
        case checkExpense
    }
    
    struct State {
        var salaryBudget: SalaryBudget = SalaryBudget(startDate: Date(), endDate: Date(), fixedIncome: 0, fixedExpense: [], balance: 0, defaultHaruby: 0, dailyBudgets: [])
        var monthlySections: [MonthlySection] = []
        
        var showWarning: Bool = false
        var yearNumber: Int = 0
        var monthNumber: Int = 0
        var focusSection: Int = 0
    }
    
    let initialState: State = .init()
    
    private let salaryBudgetRepository: SalaryBudgetRepository
    
    init() {
        guard let salaryBudgetRepository = DIContainer.shared.resolve(SalaryBudgetRepository.self) else {
            fatalError("SalaryBudgetRepository is not registered.")
        }
        self.salaryBudgetRepository = salaryBudgetRepository
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let setSalaryBudget = salaryBudgetRepository.fetch().map { salaryBudget in
                Mutation.setSalaryBudget(salaryBudget.first!)
            }
            // 상태가 업데이트된 후 createMonthSections 실행
            let updateSections = setSalaryBudget.flatMap { _ in
                Observable.just(Mutation.updateMonthSections(self.createMonthSections()))
            }
            let checkExpense = Observable.just(Mutation.checkExpense)
            return Observable.concat([setSalaryBudget, updateSections, checkExpense])
        case .scrollCalendar(let sectionIndex):
            return Observable.just(Mutation.setFocusedSection(sectionIndex))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSalaryBudget(let salaryBudget):
            newState.salaryBudget = salaryBudget
        case .updateMonthSections(let monthlySections):
            newState.monthlySections = monthlySections
            newState.yearNumber = monthlySections.first!.firstDayOfMonth.yearValue
            newState.monthNumber = monthlySections.first!.firstDayOfMonth.monthValue
        case .checkExpense:
            let hasEmptyTransactionItems = state.salaryBudget.dailyBudgets.contains { dailyBudget in
                dailyBudget.expense.transactionItems.isEmpty
            }
            newState.showWarning = hasEmptyTransactionItems
        case .setFocusedSection(let sectionIndex):
            newState.focusSection = sectionIndex
            newState.monthNumber = currentState.monthlySections[sectionIndex].firstDayOfMonth.monthValue
            newState.yearNumber = currentState.monthlySections[sectionIndex].firstDayOfMonth.yearValue
        }
        return newState
    }
}


extension CalendarViewReactor {
    // MARK: - Private Methods
    private func createMonthSections() -> [MonthlySection] {
        let calendar = Calendar.current
        let salaryStartDate = self.currentState.salaryBudget.startDate
        
        // 월급일로부터 4달의 달력데이터를 생성합니다.
        return (0...4).map { monthOffset in
            guard let monthDate = calendar.date(byAdding: .month, value: monthOffset, to: salaryStartDate) else {
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
        
        let salaryStartDate = self.currentState.salaryBudget.startDate
        let salaryEndDate = self.currentState.salaryBudget.endDate
        
        
        var dailyBudgets: [DailyBudget] = []
        
        // collection View에서 첫 주의 빈칸 채우기
        dailyBudgets.append(contentsOf: generateEmptyDays(count: firstWeekday - 1))
        
        // 해당 월에 날짜를 생성할때
        switch monthStart.monthValue {
        // 월급 시작일 ~ 말일
        case salaryStartDate.monthValue:
            let salaryBudgets = self.currentState.salaryBudget.dailyBudgets.filter { $0.date.monthValue == salaryStartDate.monthValue }
            dailyBudgets.append(contentsOf: generateDays(startDay: 1, endDay: salaryEndDate.dayValue, monthStart: monthStart, calendar: calendar))
            dailyBudgets.append(contentsOf: salaryBudgets)
        // 월초 ~ 월급 끝일
        case salaryEndDate.monthValue:
            let salaryBudgets = self.currentState.salaryBudget.dailyBudgets.filter { $0.date.monthValue == salaryEndDate.monthValue }
            dailyBudgets.append(contentsOf: salaryBudgets)
            dailyBudgets.append(contentsOf: generateDays(startDay: salaryEndDate.dayValue + 1, endDay: numberOfDaysInMonth, monthStart: monthStart, calendar: calendar))
        // 월급날에 해당하지 않는 날
        default:
            dailyBudgets.append(contentsOf: generateDays(startDay: 1, endDay: numberOfDaysInMonth, monthStart: monthStart, calendar: calendar))
        }
        
        return dailyBudgets
    }
    
    // collectionView에서 안보이는 날의 데이터를 생성하는 함수
    private func generateEmptyDays(count: Int) -> [DailyBudget] {
        return (0..<count).map { _ in
            DailyBudget(
                date: Date.distantPast,
                haruby: nil,
                memo: "",
                expense: TransactionRecord(total: 0, transactionItems: []),
                income: TransactionRecord(total: 0, transactionItems: [])
            )
        }
    }
    
    // 특정 날짜 범위에 해당하는 일별 빈 데이터를 생성하는 함수
    private func generateDays(startDay: Int, endDay: Int, monthStart: Date, calendar: Calendar) -> [DailyBudget] {
        return (startDay...endDay).map { day in
            let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart)!
            return DailyBudget(
                date: date,
                memo: "",
                expense: TransactionRecord(total: 0, transactionItems: []),
                income: TransactionRecord(total: 0, transactionItems: [])
            )
        }
    }
}


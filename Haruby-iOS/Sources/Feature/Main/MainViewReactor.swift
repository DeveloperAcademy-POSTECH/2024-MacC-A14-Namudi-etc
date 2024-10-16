//
//  MainViewReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/14/24.
//

import UIKit
import ReactorKit

final class MainViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case calculatorButtonTapped
        case calendarButtonTapped
        case managementButtonTapped
        case inputButtonTapped
    }
    
    // MARK: - Mutation
    enum Mutation {
        case updateState(State)
    }
    
    // MARK: - State
    struct State {
        var title: String
        var avgAmount: Int
        var remainingAmount: Int
        var todayAmount: Int
        var date: Date
        var harubyState: MainViewHarubyState
        var usedAmount: Int
        
        // 초기 상태를 나타내는 정적 프로퍼티
        static var initial: State {
            State(
                title: MainViewConstants.noDataTitle,
                avgAmount: 0,
                remainingAmount: 0,
                todayAmount: 0,
                date: Date(),
                harubyState: .initial,
                usedAmount: 0
            )
        }
    }
    
    // MARK: - Properties
    let initialState = State.initial
    private let container = DIContainer.shared
    private let salaryBudgetRepository: SalaryBudgetRepository
    
    // MARK: - Initialization
    init() {
        guard let repository = container.resolve(SalaryBudgetRepository.self) else {
            fatalError("SalaryBudgetRepository is not resolved")
        }
        self.salaryBudgetRepository = repository
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchAndProcessHarubyInfo()
        case .calculatorButtonTapped:
            // TODO: - 하루비 계산기 네비게이션 코디네이터 적용
            return .empty()
        case .calendarButtonTapped:
            // TODO: - 하루비 달력 네비게이션 코디네이터 적용
            return .empty()
        case .managementButtonTapped:
            // TODO: - 하루비 관리 네비게이션 코디네이터 적용
            return .empty()
        case .inputButtonTapped:
            // TODO: - 실제 지출 입력 네비게이션 코디네이터 적용
            return .empty()
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .updateState(let newState):
            return newState
        }
    }
    
    // MARK: - Private Methods
    /// 오늘의 하루비 정보를 가져와 처리하는 메서드
    private func fetchAndProcessHarubyInfo() -> Observable<Mutation> {
        let currentDate = Date()
        let startDate = calculateStartDate(from: currentDate).formattedDate
        
        return salaryBudgetRepository.read(startDate)
            .map { [weak self] salaryBudget -> State in
                guard let self = self, let salaryBudget = salaryBudget else {
                    return .initial
                }
                return self.processHarubyInfo(salaryBudget: salaryBudget, currentDate: currentDate)
            }
            .map { Mutation.updateState($0) }
    }
    
    /// 이번 기간의 시작 날짜를 계산하는 메서드
    private func calculateStartDate(from currentDate: Date) -> Date {
        let calendar = Calendar.current
        let incomeDate = UserDefaults.standard.integer(forKey: MainViewConstants.incomeDateKey)
        var startDate = currentDate
        
        // incomeDate와 일치하는 날짜를 찾을 때까지 하루씩 뒤로 이동
        while true {
            let components = calendar.dateComponents([.day], from: startDate)
            if components.day == incomeDate { break }
            startDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
        }
        
        return startDate
    }
    
    /// 오늘의 하루비 정보를 처리하는 메서드
    private func processHarubyInfo(salaryBudget: SalaryBudget, currentDate: Date) -> State {
        let calendar = Calendar.current
        let todayDailyBudget = salaryBudget.dailyBudgets.first {
            calendar.isDate($0.date, inSameDayAs: currentDate)
        }
        
        let (title, remainingAmount) = setTitleAndRemain(for: todayDailyBudget)
        let avgAmount = calculateAverageHaruby(endDate: salaryBudget.endDate, balance: salaryBudget.balance)
        let harubyState = MainViewHarubyState(remainingAmount: remainingAmount, todayDailyBudget: todayDailyBudget)
        
        return State(
            title: title,
            avgAmount: avgAmount,
            remainingAmount: remainingAmount,
            todayAmount: todayDailyBudget?.haruby ?? 0,
            date: todayDailyBudget?.date ?? currentDate,
            harubyState: harubyState,
            usedAmount: todayDailyBudget?.expense.total ?? 0
        )
    }
    
    /// 실제 지출을 입력했는지 여부에 따라 타이틀과 남은 금액 설정
    private func setTitleAndRemain(for dailyBudget: DailyBudget?) -> (title: String, amount: Int) {
        guard let dailyBudget = dailyBudget else {
            return (MainViewConstants.todayHarubyTitle, 0)
        }
        
        if dailyBudget.expense.total == 0 {
            return (MainViewConstants.todayHarubyTitle, dailyBudget.haruby ?? 0)
        } else {
            return (MainViewConstants.remainingHarubyTitle, (dailyBudget.haruby ?? 0) - dailyBudget.expense.total)
        }
    }
    
    /// 평균 하루비를 계산하는 메서드
    private func calculateAverageHaruby(endDate: Date, balance: Int) -> Int {
        HarubyCalculateManager.getAverageHarubyFromNow(endDate: endDate, balance: balance)
    }
}

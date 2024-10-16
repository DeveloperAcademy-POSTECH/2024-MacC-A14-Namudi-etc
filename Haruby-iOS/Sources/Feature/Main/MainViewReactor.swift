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
        case updateState(SalaryBudget, DailyBudget)
        case updateViewState(ViewState)
    }
    
    // MARK: - State
    struct State {
        var viewState: ViewState
        var salaryBudget: SalaryBudget?
        var dailyBudget: DailyBudget?
    }
    
    struct ViewState {
        var title: String = ""
        var avgAmount: Int = 0
        var remainingAmount: Int = 0
        var todayAmount: Int = 0
        var date: Date = Date()
        var harubyState: MainViewHarubyState = MainViewHarubyState.initial
        var usedAmount: Int = 0
    }
    
    // MARK: - Properties
    let initialState = State(viewState: ViewState())
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
        var newState = state
        switch mutation {
        case .updateState(let salaryBudget, let dailyBudget):
            newState.salaryBudget = salaryBudget
            newState.dailyBudget = dailyBudget
            newState.viewState = processViewState(salaryBudget: salaryBudget, dailyBudget: dailyBudget)
        case .updateViewState(let viewState):
            newState.viewState = viewState
        }
        return newState
    }
}

// MARK: - Private Methods
extension MainViewReactor {
    /// 오늘의 하루비 정보를 가져와 처리하는 메서드
    private func fetchAndProcessHarubyInfo() -> Observable<Mutation> {
        let incomeDate = UserDefaultsManager.getIncomeDate()
        let startDate = BudgetManager.calculateStartDate(from: Date(), incomeDate: incomeDate)
        
        return salaryBudgetRepository.read(startDate)
            .map { salaryBudget -> Mutation in
                guard let salaryBudget = salaryBudget else {
                    print("salaryBudget not found")
                    return .updateViewState(ViewState())
                }
                let dailyBudget = salaryBudget.dailyBudgets.first {
                    Calendar.current.isDate($0.date, inSameDayAs: Date())
                }
                guard let dailyBudget else {
                    print("dailyBudget not found")
                    return .updateViewState(ViewState())
                }
                return .updateState(salaryBudget, dailyBudget)
            }
    }
    
    /// 오늘의 하루비 정보로 뷰 상태를 업데이트하는 메서드
    private func processViewState(salaryBudget: SalaryBudget, dailyBudget: DailyBudget) -> ViewState {
        let (title, remainingAmount) = self.setTitleAndRemain(for: dailyBudget)
        let avgAmount = HarubyCalculateManager
            .getAverageHarubyFromNow(endDate: salaryBudget.endDate, balance: salaryBudget.balance)
        let harubyState = MainViewHarubyState(remainingAmount: remainingAmount, todayDailyBudget: dailyBudget)
        
        return ViewState(
            title: title,
            avgAmount: avgAmount,
            remainingAmount: remainingAmount,
            todayAmount: dailyBudget.haruby ?? 0,
            date: dailyBudget.date,
            harubyState: harubyState,
            usedAmount: dailyBudget.expense.total
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
}

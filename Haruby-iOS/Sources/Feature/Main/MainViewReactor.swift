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
        case initView
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
        var usedAmount: Int = 0
        var harubyState: MainViewHarubyState = .initial
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
        case .initView:
            return fetchAndProcessHarubyInfo()
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
    private func fetchAndProcessHarubyInfo() -> Observable<Mutation> {
        let incomeDate = UserDefaultsManager.getIncomeDate()
        let startDate = BudgetManager.calculateStartDate(from: Date(), incomeDate: incomeDate)
        
        return salaryBudgetRepository.read(startDate)
            .map { salaryBudget -> Mutation in
                guard let salaryBudget = salaryBudget,
                      let dailyBudget = salaryBudget.dailyBudgets.first(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) else {
                    print("salaryBudget or dailyBudget not found")
                    return .updateViewState(ViewState())
                }
                return .updateState(salaryBudget, dailyBudget)
            }
    }
    
    private func processViewState(salaryBudget: SalaryBudget, dailyBudget: DailyBudget) -> ViewState {
        let avgAmount = HarubyCalculateManager.getAverageHarubyFromNow(endDate: salaryBudget.endDate, balance: salaryBudget.balance)
        let todayAmount = dailyBudget.haruby ?? salaryBudget.defaultHaruby
        let totalExpense = dailyBudget.expense.total
        let remainingAmount = todayAmount - totalExpense
        let harubyState: MainViewHarubyState =
        totalExpense > 0 ? (remainingAmount >= 0 ? .positive : .negative) : .initial
        
        return ViewState(
            title: harubyState.title,
            avgAmount: avgAmount,
            remainingAmount: remainingAmount,
            todayAmount: todayAmount,
            date: dailyBudget.date,
            usedAmount: totalExpense,
            harubyState: harubyState
        )
    }
}

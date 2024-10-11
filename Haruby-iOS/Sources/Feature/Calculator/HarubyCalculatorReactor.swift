//
//  HarubyCalculatorReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import Foundation
import ReactorKit

final class HarubyCalculatorReactor: Reactor {
    enum Action {
        case updateExpense(String)
        case calculate
    }
    
    enum Mutation {
        case setExpense(Int?)
        case setResult(String)
    }
    
    struct State {
        var currentHaruby: Int
        var expense: Int?
        var result: String
    }
    
    let initialState: State
    private var calculatorManager: HarubyCalculateManager = HarubyCalculateManager()
    
    init() {
        self.initialState = State(currentHaruby: 0, expense: nil, result: "")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateExpense(let expenseString):
            let expense = Int(expenseString)
            return .just(.setExpense(expense))
        case .calculate:
            guard let expense = currentState.expense else {
                return .just(.setResult("유효한 지출 금액을 입력해주세요."))
            }
            return .just(.setResult("남은 하루비: \(expense)원"))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setExpense(let expense):
            newState.expense = expense
        case .setResult(let result):
            newState.result = result
        }
        return newState
    }
}

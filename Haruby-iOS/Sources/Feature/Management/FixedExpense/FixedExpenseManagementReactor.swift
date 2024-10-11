//
//  FixedExpenseManagementReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import Foundation
import ReactorKit

class FixedExpenseManagementReactor: Reactor {
    enum Action {
        case fetchExpense
        case addExpense
        case removeExpense
    }
    
    enum Mutation {
        case fetchExpense
        case appendExpense
    }
    
    struct State {
        var expenses: [Int]
    }
    
    let initialState: State
    
    init(expenses: [Int] = []) {
        self.initialState = State(expenses: expenses)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchExpense:
            return .empty()
        case .addExpense:
            return .empty()
        case .removeExpense:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchExpense:
            newState.expenses = [1, 2, 3]
        case .appendExpense:
            newState.expenses.append(4)
        }
        return newState
    }
}

struct FixedExpense {
    let name: String
    let amount: Int
}

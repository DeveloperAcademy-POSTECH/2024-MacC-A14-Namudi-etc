//
//  FixedIncomeManagementReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import Foundation
import ReactorKit

class FixedIncomeManagementReactor: Reactor {
    enum Action {
        case fetchIncone
        case addIncome
        case removeIncome
    }
    
    enum Mutation {
        case fetchIncome
        case appendIncome
    }
    
    struct State {
        var incomes: [Int]
    }
    
    let initialState: State
    
    init(incomes: [Int] = []) {
        self.initialState = State(incomes: incomes)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addIncome:
            return .empty()
        case .fetchIncone:
            return .empty()
        case .removeIncome:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchIncome:
            newState.incomes = [1, 2, 3]
        case .appendIncome:
            newState.incomes.append(4)
        }
        return newState
    }
}

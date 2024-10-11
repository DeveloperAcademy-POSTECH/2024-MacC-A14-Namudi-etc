//
//  SpendingInputReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import Foundation
import ReactorKit

class SpendingInputReactor: Reactor {
    enum Action {
        case updateAmount(String)
        case updateCategory(String)
        case save
    }
    
    enum Mutation {
        case setAmount(String)
        case setCategory(String)
        case setSaveEnabled(Bool)
    }
    
    struct State {
        var amount: String = ""
        var category: String = ""
        var isSaveEnabled: Bool = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateAmount(let amount):
            return .concat([
                .just(.setAmount(amount)),
                .just(.setSaveEnabled(!amount.isEmpty && !currentState.category.isEmpty))
            ])
        case .updateCategory(let category):
            return .concat([
                .just(.setCategory(category)),
                .just(.setSaveEnabled(!currentState.amount.isEmpty && !category.isEmpty))
            ])
        case .save:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setAmount(let amount):
            newState.amount = amount
        case .setCategory(let category):
            newState.category = category
        case .setSaveEnabled(let isEnabled):
            newState.isSaveEnabled = isEnabled
        }
        return newState
    }
}

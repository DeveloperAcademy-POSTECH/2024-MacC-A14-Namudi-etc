//
//  HarubyOrTransactionSelectorViewReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/15/24.
//

import UIKit

import ReactorKit
import RxSwift

class HarubyOrTransactionSelectorViewReactor: Reactor {
    enum Action {
        case harubyButtonTapped
        case transactionButtonTapped
    }
    
    enum Mutation {
        case setHarubyButtonState(Bool)
        case setTransactionButtonState(Bool)
    }
    
    struct State {
        var dailyBudget: DailyBudget
        var isHarubyButtonTapped = false
        var isTransactionButtonTapped = false
    }
    
    let initialState: State
    
    init(dailyBudget: DailyBudget){
        self.initialState = State(dailyBudget: dailyBudget)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        // code
        switch action {
        case .harubyButtonTapped:
            let setButtonStateTrue = Observable.just(Mutation.setHarubyButtonState(true))
            let setButtonStateFalse = Observable.just(Mutation.setHarubyButtonState(false))
            return Observable.concat([setButtonStateTrue, setButtonStateFalse])
        case .transactionButtonTapped:
            let setButtonStateTrue = Observable.just(Mutation.setTransactionButtonState(true))
            let setButtonStateFalse = Observable.just(Mutation.setTransactionButtonState(false))
            return Observable.concat([setButtonStateTrue, setButtonStateFalse])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            case .setHarubyButtonState(let isHarubyButtonTapped):
            newState.isHarubyButtonTapped = isHarubyButtonTapped
        case .setTransactionButtonState(let isTransactionButtonTapped):
            newState.isTransactionButtonTapped = isTransactionButtonTapped
        }
        return newState
    }
    
    // MARK: - Private Methods
}

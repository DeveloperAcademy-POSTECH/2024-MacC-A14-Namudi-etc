//
//  InputViewReactor.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/13/24.
//

import UIKit
import ReactorKit
import RxSwift

final class InputViewReactor: Reactor {
    enum Action {
        case toggleDetailButton
    }
    
    enum Mutation {
        case setDetailVisible(Bool)
    }
    
    struct State {
        var isDetailVisible: Bool = false
    }
    
    var initialState: State = State()
    
    func mutation(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleDetailButton:
            return Observable.just(.setDetailVisible(!currentState.isDetailVisible))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDetailVisible(let isVisible):
            newState.isDetailVisible = isVisible
        }
        
        return newState
    }
}

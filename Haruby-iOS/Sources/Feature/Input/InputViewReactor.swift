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
        case toggleDatePicker
    }
    
    enum Mutation {
        case setDetailVisible(Bool)
        case setDatePickerVisible(Bool)
    }
    
    struct State {
        var isDetailVisible: Bool = false
        var isDatePickerVisible: Bool = false
    }
    
    private(set) var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleDetailButton:
            let isDetailVisible = !currentState.isDetailVisible
            return Observable.just(.setDetailVisible(isDetailVisible))
            
        case .toggleDatePicker:
            let isDatePickerVisible = !currentState.isDatePickerVisible
            return Observable.just(.setDatePickerVisible(isDatePickerVisible))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setDetailVisible(isVisible):
            newState.isDetailVisible = isVisible
            
        case let .setDatePickerVisible(isVisible):
            newState.isDatePickerVisible = isVisible
        }
        
        return newState
    }
}

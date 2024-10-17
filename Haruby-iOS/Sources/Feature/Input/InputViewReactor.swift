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
        case selectTransactionType(String)
        case tapAddDetailTransactionButton // 너무 긴가 ..
    }
    
    enum Mutation {
        case setDetailVisible(Bool)
        case setDatePickerVisible(Bool)
        case setTransactionType(String)
        case addDetailTransaction
    }
    
    struct State {
        var isDetailVisible: Bool = false
        var isDatePickerVisible: Bool = false
        var transactionType: String = "지출"
        var detailTransaction: [String] = []
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
            
        case .selectTransactionType(let newType):
            return Observable.just(.setTransactionType(newType))
            
        case .tapAddDetailTransactionButton:
            return Observable.just(.addDetailTransaction)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setDetailVisible(isVisible):
            newState.isDetailVisible = isVisible
            
        case let .setDatePickerVisible(isVisible):
            newState.isDatePickerVisible = isVisible
            
        case let .setTransactionType(newType):
            newState.transactionType = newType
            
        case .addDetailTransaction:
            newState.detailTransaction.append("New Cellㅋ")
        }
        
        return newState
    }
}

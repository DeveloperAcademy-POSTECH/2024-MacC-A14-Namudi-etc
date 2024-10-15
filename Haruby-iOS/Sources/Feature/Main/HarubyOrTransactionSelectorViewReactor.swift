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
        case closeButtonTapped
        case harubyButtonTapped
        case transactionButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        // code
        switch action {
        case .closeButtonTapped:
            print("closeButtonTapped")
            return .empty()
        case .harubyButtonTapped:
            print("harubyButtonTapped")
            return .empty()
        case .transactionButtonTapped:
            print("transactionButtonTapped")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        // code
    }
    
    // MARK: - Private Methods
}

//
//  HarubyEditViewReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/12/24.
//

import ReactorKit
import RxSwift

final class HarubyEditViewReactor: Reactor {
    enum Action {
        case bottomButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var memoText = ""
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .bottomButtonTapped:
            print("bottomButtonTapped")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
    
    // MARK: - Private Methods
}

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
        case editMemoText(String)
        case bottomButtonTapped
    }
    
    enum Mutation {
        case setMemoText(String)
    }
    
    struct State {
        var memoText = ""
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .editMemoText(let memoText):
            let prefixedText = String(memoText.prefix(30))
            return Observable.just(.setMemoText(prefixedText))
            
        case .bottomButtonTapped:
            print("bottomButtonTapped")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMemoText(let memoText):
            newState.memoText = memoText
            print(newState.memoText)
        }
        return newState
    }
    
    // MARK: - Private Methods

}

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
        case editHarubyText(String)
        case editMemoText(String)
        case bottomButtonTapped
    }
    
    enum Mutation {
        case setHarubyText(String)
        case setMemoText(String)
    }
    
    struct State {
        var dailyBudget: DailyBudget?
        var harubyText = ""
        var memoText = ""
    }
    
    let initialState: State
    
    init(dailyBudget: DailyBudget){
        self.initialState = State(dailyBudget: dailyBudget, harubyText: dailyBudget.haruby?.decimalWithWon ?? "")
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .editHarubyText(let harubyText):
            print(harubyText)
            return Observable.just(.setHarubyText(harubyText))
            
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
        case .setHarubyText(let harubyText):
            newState.harubyText = harubyText
        case .setMemoText(let memoText):
            newState.memoText = memoText
        }
        return newState
    }
    
    // MARK: - Private Methods

}

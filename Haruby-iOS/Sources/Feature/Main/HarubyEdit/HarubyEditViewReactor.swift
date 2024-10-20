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
        case setHaruby(Int)
        case setHarubyText(String)
        case setMemoText(String)
    }
    
    struct State {
        var dailyBudget: DailyBudget?
        var haruby = 0
        var harubyText = ""
        var memoText = ""
    }
    
    let initialState: State
    //let repository: SalaryBudgetRepository
    
    init(dailyBudget: DailyBudget){
        // TODO: SalaryBudget의 default하루비 가져오기
        self.initialState = State(dailyBudget: dailyBudget, memoText: dailyBudget.memo)
//        guard let repository = DIContainer.shared.resolve(SalaryBudgetRepository.self) else {
//            fatalError("SalaryBudgetRepository is not registered.")
//        }
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .editHarubyText(let harubyText):
            let (harubyNumber, newText) = processHarubyText(harubyText)
            
            let setHaruby = Observable.just(Mutation.setHaruby(harubyNumber))
            let setHarubyText = Observable.just(Mutation.setHarubyText(newText))
            
            return Observable.concat([setHaruby, setHarubyText])
            
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
        case .setHaruby(let haruby):
            newState.haruby = haruby
        case .setHarubyText(let harubyText):
            newState.harubyText = harubyText
        case .setMemoText(let memoText):
            newState.memoText = memoText
        }
        return newState
    }
    
    // MARK: - Private Methods
    private func processHarubyText(_ harubyText: String) -> (Int, String) {
        var harubyNumber = 0
        var newText = ""
        
        if harubyText.isEmpty || harubyText == "원" {
            newText = ""
        } else {
            harubyNumber = harubyText.numberFormat ?? 0
            newText = harubyNumber.decimalWithWon
        }
        
        return (harubyNumber, newText)
    }
}

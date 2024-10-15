//
//  CalculationViewReactor.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/14/24.
//

import Foundation
import ReactorKit
import RxSwift

final class CalculationViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case resultButtonTapped
        case numberButtonTapped(String)
        case operatorButtonTapped(String)
        case deleteButtonTapped(String)
        
    }
    
    enum Mutation {
        case initializeData
        case updateAverageHaruby(Int) // 평균 하루비, 지출 예정 금액, 입력 필드 업데이트
        case updateEstimatedPrice(Int)
        case updateInputField(String)
    }
    
    struct State {
        var isResultButtonClicked: Bool = false
        var averageHaruby: Int = 0
        var remainTotalHaruby: Int = 0
        var estimatedPrice: Int = 0
        var remainingDays: Int = 0
        var inputFieldText: String = ""
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.initializeData)
        case .resultButtonTapped:
            return .concat([
                updateHaruby(),
                updateEstimatedPrice(),
                updateInputTextField("")
            ])
        case .numberButtonTapped(let text),
                .operatorButtonTapped(let text),
                .deleteButtonTapped(let text):
            return updateInputTextField(text)
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .initializeData:
            break
        case .updateAverageHaruby(let haruby):
            newState.averageHaruby = haruby
        case .updateEstimatedPrice(let price):
            newState.estimatedPrice = price
        case .updateInputField(let text):
            newState.inputFieldText = text
        }
        return newState
    }
}

extension CalculationViewReactor {
    private func updateHaruby() -> Observable<Mutation> {
        .empty()
    }
    
    private func updateEstimatedPrice() -> Observable<Mutation> {
        .empty()
    }
    
    private func updateInputTextField(_ text: String) -> Observable<Mutation> {
        print(text)
        return .empty()
    }
}

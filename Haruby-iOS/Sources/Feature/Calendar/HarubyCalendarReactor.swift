//
//  HarubyCalendarReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import Foundation
import ReactorKit

final class HarubyCalendarReactor: Reactor {
    enum Action {
        case inputButtonTapped
        case detailButtonTapped
        case dateSelected(Date)
    }
    
    enum Mutation {
        case setSelectedDate(Date)
        case showSpendingInput
    }
    
    struct State {
        var selectedDate: Date
    }
    
    let initialState: State
    weak var coordinator: HarubyCalendarCoordinator?
    
    init(coordinator: HarubyCalendarCoordinator) {
        self.coordinator = coordinator
        self.initialState = State(selectedDate: Date())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputButtonTapped:
            return .just(.showSpendingInput)
        case .detailButtonTapped:
            return .empty()
        case .dateSelected(let date):
            return .just(.setSelectedDate(date))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedDate(let date):
            newState.selectedDate = date
        case .showSpendingInput:
            coordinator?.showSpendingInput()
        }
        return newState
    }
}

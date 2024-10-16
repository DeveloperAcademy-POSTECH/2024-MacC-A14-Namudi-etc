//
//  HarubyManagementReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import Foundation
import ReactorKit

final class HarubyManagementReactor: Reactor {
    enum Action {
        case appSettingsButtonTapped
        case fixedIncomeButtonTapped
        case fixedExpenseButtonTapped
    }
    
    enum Mutation {
        case showAppSettings
        case showFixedIncomeManagement
        case showFixedExpenseManagement
    }
    
    struct State { }
    
    let initialState: State
    let coordinator: ManagementCoordinator
    
    init(coordinator: ManagementCoordinator) {
        self.coordinator = coordinator
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appSettingsButtonTapped:
            return Observable.just(.showAppSettings)
        case .fixedIncomeButtonTapped:
            return Observable.just(.showFixedIncomeManagement)
        case .fixedExpenseButtonTapped:
            return Observable.just(.showFixedExpenseManagement)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
            case .showAppSettings:
            coordinator.showAppSettings()
            case .showFixedIncomeManagement:
            coordinator.showFixedIncomeManagement()
            case .showFixedExpenseManagement:
            coordinator.showFixedExpenseManagement()
        }
        return state
    }
}

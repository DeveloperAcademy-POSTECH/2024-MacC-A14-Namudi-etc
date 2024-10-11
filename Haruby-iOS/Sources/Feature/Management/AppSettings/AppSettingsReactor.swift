//
//  AppSettingsReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import Foundation
import ReactorKit

class AppSettingsReactor: Reactor {
    enum Theme: Int {
        case light = 0
        case dark = 1
        case system = 2
    }
    
    enum Action {
        case setNotification(Bool)
        case setTheme(Theme)
    }
    
    enum Mutation {
        case setNotificationStatus(Bool)
        case setThemeStatus(Theme)
    }
    
    struct State {
        var isNotificationOn: Bool
        var theme: Theme
    }
    
    let initialState: State
    
    init(isNotificationOn: Bool = false, theme: Theme = .system) {
        self.initialState = State(isNotificationOn: isNotificationOn, theme: theme)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setNotification(let isOn):
            return .just(.setNotificationStatus(isOn))
        case .setTheme(let theme):
            return .just(.setThemeStatus(theme))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNotificationStatus(let isOn):
            newState.isNotificationOn = isOn
        case .setThemeStatus(let theme):
            newState.theme = theme
        }
        return newState
    }
}

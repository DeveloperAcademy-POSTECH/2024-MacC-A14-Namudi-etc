//
//  MainReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/14/24.
//

import UIKit
import ReactorKit

final class MainReactor: Reactor {
    enum Action {
        case viewDidLoad
        case naivgateCalculator
        case navigateCalendar
        case navigateManagement
        case navigateInputButton
    }
    
    enum Mutation {
        case setAvgHaruby(String)
        case setTodayHaruby(String)
        case setDate(String)
    }
    
    struct State {
        var avgHaruby: String = ""
        var todayHaruby: String = ""
        var date: String = ""
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            // TODO: - 메인 뷰 초기 데이터 설정 로직
            print("viewDidLoad")
            return Observable.concat([
                Observable.just(Mutation.setAvgHaruby("10,000원")),
                Observable.just(Mutation.setTodayHaruby("36,000원")),
                Observable.just(Mutation.setDate(Date.todayString()))
            ])
        case .naivgateCalculator:
            // TODO: - 하루비 계산기 네비게이션 로직
            print("navigateCalculator tapped")
            return .empty()
        case .navigateCalendar:
            // TODO: - 하루비 달력 네비게이션 로직
            print("navigateCalendar tapped")
            return .empty()
        case .navigateManagement:
            // TODO: - 하루비 관리 네비게이션 로직
            print("navigateManagement tapped")
            return .empty()
        case .navigateInputButton:
            // TODO: - 지출 입력 네비게이션 로직
            print("navigateInputButton tapped")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setAvgHaruby(let avg):
            newState.avgHaruby = avg
        case .setTodayHaruby(let today):
            newState.todayHaruby = today
        case .setDate(let date):
            newState.date = date
        }
        return newState
    }
}

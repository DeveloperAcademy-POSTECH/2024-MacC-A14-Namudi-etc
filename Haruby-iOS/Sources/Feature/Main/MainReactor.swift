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
        case updateMainState(MainState)
    }
    
    struct MainState {
        var todayHarubyTitle: String
        var avgHaruby: String
        var todayHaruby: String
        var date: String
    }
    
    struct State {
        var mainState: MainState = MainState(todayHarubyTitle: "", avgHaruby: "", todayHaruby: "", date: "")
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            // TODO: - 메인 뷰 초기 데이터 설정 로직
            /*
            1. salraryBudget.dailyBudgets 에서 filter로 오늘 날짜의 dailyBudget을 불러온다.
            2. dailyBudget.date를 표시한다.
            3. dailyBudget.expense.total이 0이라면 dailyBudget.haruby를 표시
                ("오늘의 하루비)
            4. dailyBudget.expense.total이 0이 아니라면 dailyBudget.haruby - dailyBudget.expense.toal 표시
                ("오늘의 남은 하루비")
            5. dailyBudget.haruby - dailyBudget.expense.toal이 양수인지 음수인지 판단
            6. 판단에 따라 amountBox와 amountLabel의 색상 바꾸고 사용한 금액 Label로 표시
             */
            print("MainView DidLoad")
            let newState = MainState(
                todayHarubyTitle: "오늘의 하루비",
                avgHaruby: "10,000원",
                todayHaruby: "36,000원",
                date: Date().formattedDateToStringforMainView
            )
            return Observable.just(.updateMainState(newState))
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
        case .updateMainState(let mainState):
            newState.mainState = mainState
        }
        return newState
    }
}

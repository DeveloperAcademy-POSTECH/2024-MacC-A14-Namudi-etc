//
//  MainReactor.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/14/24.
//

import UIKit
import ReactorKit

final class MainReactor: Reactor {
    // MARK: - Action, Mutation, State
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
        var remainHaruby: String
        var todayHaruby: String
        var date: String
        var harubyImage: UIImage
        var amountBoxColor: UIColor
        var amountLabelColor: UIColor
        var usedAmount: Int
    }
    
    enum HarubyState {
        case initial
        case positive
        case negative

        var uiProperties: (boxColor: UIColor, labelColor: UIColor, image: UIImage) {
            switch self {
            case .initial:
                return (UIColor.Haruby.whiteDeep, UIColor.Haruby.main, .purpleHaruby)
            case .positive:
                return (UIColor.Haruby.green10, UIColor.Haruby.green, .greenHaruby)
            case .negative:
                return (UIColor.Haruby.red10, UIColor.Haruby.red, .redHaruby)
            }
        }
    }
    
    struct State {
        var mainState: MainState = MainState(todayHarubyTitle: "",
                                             avgHaruby: "",
                                             remainHaruby: "",
                                             todayHaruby: "",
                                             date: "",
                                             harubyImage: .purpleHaruby,
                                             amountBoxColor: .Haruby.mainBright,
                                             amountLabelColor: .Haruby.main,
                                             usedAmount: 0)
    }
    
    // MARK: - Properties
    let initialState = State()
    let container = DIContainer.shared
    private let salaryBudgetRepository: SalaryBudgetRepository?
    
    init() {
        let resolve = container.resolve(SalaryBudgetRepository.self)
        guard let salaryBudgetRepository = resolve else {
            fatalError("SalaryBudgetRepository is not resolved")
        }
        self.salaryBudgetRepository = salaryBudgetRepository
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let calendar = Calendar.current
            let currentDate = Date()
            let incomeDate = UserDefaults.standard.integer(forKey: "incomeDate")
            
            // 현재 날짜에서 시작해 incomeDate와 일치하는 날짜를 찾습니다
            var startDate = currentDate
            while true {
                let components = calendar.dateComponents([.day], from: startDate)
                if components.day == incomeDate {
                    break
                }
                startDate = calendar.date(byAdding: .day, value: -1, to: startDate)!.formattedDate
                
            }
            return salaryBudgetRepository!.read(startDate)
                .flatMap { salaryBudget -> Observable<Mutation> in
                    guard let salaryBudget = salaryBudget else {
                        return .just(.updateMainState(MainState(
                            todayHarubyTitle: "데이터 없음",
                            avgHaruby: "0원",
                            remainHaruby: "0원",
                            todayHaruby: "0원",
                            date: currentDate.formattedDateToStringforMainView,
                            harubyImage: .purpleHaruby,
                            amountBoxColor: .Haruby.mainBright,
                            amountLabelColor: .Haruby.main,
                            usedAmount: 0
                        )))
                    }
                    
                    // 오늘 날짜의 dailyBudget 찾기
                    let todayDailyBudget = salaryBudget.dailyBudgets.first {
                        calendar.isDate($0.date, inSameDayAs: currentDate)
                    }
                    
                    // 하루비 계산
                    let harubyTitle: String
                    let harubyAmount: Int
                    if let todayDailyBudget = todayDailyBudget {
                        if todayDailyBudget.expense.total == 0 {
                            harubyTitle = "오늘의 하루비"
                            harubyAmount = todayDailyBudget.haruby!
                        } else {
                            harubyTitle = "오늘의 남은 하루비"
                            harubyAmount = todayDailyBudget.haruby! - todayDailyBudget.expense.total
                        }
                    } else {
                        harubyTitle = "오늘의 하루비"
                        harubyAmount = 0 // 또는 기본값 설정
                    }
                    
                    let avgHaruby = HarubyCalculateManager
                        .getAverageHarubyFromNow(endDate: salaryBudget.endDate, balance: salaryBudget.balance)
                    
                    // 금액에 따른 UI 상태 결정
                    let harubyState: HarubyState
                    if let todayDailyBudget = todayDailyBudget, todayDailyBudget.expense.total > 0 {
                        harubyState = harubyAmount > 0 ? .positive : .negative
                    } else {
                        harubyState = .initial
                    }

                    let (amountBoxColor, amountLabelColor, harubyImage) = harubyState.uiProperties
                    
                    let newState = MainState(
                        todayHarubyTitle: harubyTitle,
                        avgHaruby: avgHaruby.decimalWithWon,
                        remainHaruby: harubyAmount.decimalWithWon,
                        todayHaruby: todayDailyBudget?.haruby?.decimalWithWon ?? "",
                        date: todayDailyBudget?.date.formattedDateToStringforMainView ?? "",
                        harubyImage: harubyImage,
                        amountBoxColor: amountBoxColor,
                        amountLabelColor: amountLabelColor,
                        usedAmount: todayDailyBudget?.expense.total ?? 0
                    )
                    
                    return .just(.updateMainState(newState))
                }
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
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateMainState(let mainState):
            newState.mainState = mainState
        }
        return newState
    }
    
    // MARK: - Private Methods
    
}

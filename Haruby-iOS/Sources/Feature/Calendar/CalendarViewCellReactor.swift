//
//  CalendarViewCellReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/10/24.
//

import UIKit

import ReactorKit
import RxSwift

final class CalendarViewCellReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var dayNumber: String           // 날짜 숫자
        var isVisible: Bool             // 셀이 표시 가능한지 여부
        var isToday: Bool               // 오늘 날짜인지 여부
        var haruby: String?             // 하루비
        var memo: String?               // 메모
        var expense: TransactionRecord? // 지출
        var income: TransactionRecord?  // 수입
    }
    
    let initialState: State
    
    // 2. 데이터 바인딩
    //      case1-dailyBudget에 있는 날짜이면 하이라이트
    //              a. 하루비를 조정했는지 여부
    //              b. 오늘날짜를 지났으면 지출을 입력했는지 여부
    //              c. 하루비를 조정했다면 조정 하루비 보여주기, 조정을 안했다면 기본 하루비 보여주기
    //      case2 -dailyBudget에 없는 날짜이면 하이라이트 없기
    
    init(dailyBudget: DailyBudget) {
        
        let calendar = Calendar.current
        
        let dayNumber = "\(calendar.component(.day, from: dailyBudget.date))"
        let monthNumber = "\(calendar.component(.month, from: dailyBudget.date))"

        let isFirstDayOfMonth = dayNumber == "1" ? true : false

        initialState = State(
            dayNumber: isFirstDayOfMonth ? "\(monthNumber)/\(dayNumber)" : dayNumber,
            isVisible: dailyBudget.date != Date.distantPast ? true : false,
            isToday: calendar.isDate(dailyBudget.date, inSameDayAs: Date()),
            haruby: dailyBudget.haruby?.decimal ?? nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        // code
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        // code
    }
    
    // MARK: - Private Methods
}

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
    
    init(dayItem: DayItem) {
        
        let calendar = Calendar.current
        
        let dayNumber = dayItem.date.map { "\(calendar.component(.day, from: $0))" } ?? ""
        let monthNumber = dayItem.date.map { "\(calendar.component(.month, from: $0))" } ?? ""

        let isFirstDayOfMonth = dayItem.date.map { calendar.component(.day, from: $0) == 1 } ?? false

        initialState = State(
            dayNumber: isFirstDayOfMonth ? "\(monthNumber)/\(dayNumber)" : dayNumber,
            isVisible: dayItem.date != nil,
            isToday: dayItem.isToday
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

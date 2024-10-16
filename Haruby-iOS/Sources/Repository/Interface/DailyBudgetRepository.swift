//
//  DailyBudgetRepository.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/16/24.
//

import Foundation
import RxSwift

protocol DailyBudgetRepository: AnyObject {
    func read(_ date: Date) -> Observable<DailyBudget?>
    func updateHaruby(_ id: String, haruby: Int) -> Observable<Void>
    func updateMemo(_ id: String, memo: String) -> Observable<Void>
    func updateExpense(_ id: String, expense: TransactionRecord) -> Observable<Void>
    func updateIncome(_ id: String, income: TransactionRecord) -> Observable<Void>
}

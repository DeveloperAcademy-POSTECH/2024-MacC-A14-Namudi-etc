//
//  SalaryBudgetRepository.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/16/24.
//

import Foundation
import RxSwift

protocol SalaryBudgetRepository: AnyObject {
    func create(_ salaryBudget: SalaryBudget) -> Observable<Void>
    
    func fetch() -> Observable<[SalaryBudget]>
    func read(_ startDate: Date) -> Observable<SalaryBudget?>
    
    func updateDate(_ id: String, start: Date, end:Date) -> Observable<Void>
    func updateFixedIncome(_ id: String, fixedIncome: Int) -> Observable<Void>
    func updateFixedExpense(_ id: String, fixedExpense: [TransactionItem]) -> Observable<Void>
    func updateBalance(_ id: String, balance: Int) -> Observable<Void>
    func updateDefaultHaruby(_ id: String, defaultHaruby: Int) -> Observable<Void>
    
    func delete(_ id: String) -> Observable<Void>
}

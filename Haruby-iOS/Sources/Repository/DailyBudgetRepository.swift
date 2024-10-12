//
//  DailyBudgetRepository.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/12/24.
//

import Foundation
import RxSwift

protocol DailyBudgetRepository: AnyObject {
    func read(_ date: Date) -> Observable<DailyBudget>
    func updateHaruby(_ id: String, haruby: Int) -> Observable<Void>
    func updateMemo(_ id: String, memo: String) -> Observable<Void>
    func updateExpense(_ id: String, expense: TransactionRecord) -> Observable<Void>
    func updateIncome(_ id: String, income: TransactionRecord) -> Observable<Void>
}

// MARK: - Impl
final class DailyBudgetRepositoryImpl: DailyBudgetRepository {
    func read(_ date: Date) -> Observable<DailyBudget> {
        print("Impl: Read DailyBudget \(date)")
        return .empty()
    }
    
    func updateHaruby(_ id: String, haruby: Int) -> Observable<Void> {
        print("Impl: Update Haruby \(haruby)")
        return .empty()
    }
    
    func updateMemo(_ id: String, memo: String) -> Observable<Void> {
        print("Impl: Update Memo \(memo)")
        return .empty()
    }
    
    func updateExpense(_ id: String, expense: TransactionRecord) -> Observable<Void> {
        print("Impl: Update Expense \(expense)")
        return .empty()
    }
    
    func updateIncome(_ id: String, income: TransactionRecord) -> Observable<Void> {
        print("Impl: Update Income \(income)")
        return .empty()
    }
}

// MARK: - Stub
final class StubDailyBudgetRepository: DailyBudgetRepository {
    func read(_ date: Date) -> Observable<DailyBudget> {
        print("Stub: Read DailyBudget \(date)")
        return .empty()
    }
    
    func updateHaruby(_ id: String, haruby: Int) -> Observable<Void> {
        print("Stub: Update Haruby \(haruby)")
        return .empty()
    }
    
    func updateMemo(_ id: String, memo: String) -> Observable<Void> {
        print("Stub: Update Memo \(memo)")
        return .empty()
    }
    
    func updateExpense(_ id: String, expense: TransactionRecord) -> Observable<Void> {
        print("Stub: Update Expense \(expense)")
        return .empty()
    }
    
    func updateIncome(_ id: String, income: TransactionRecord) -> Observable<Void> {
        print("Stub: Update Income \(income)")
        return .empty()
    }
}

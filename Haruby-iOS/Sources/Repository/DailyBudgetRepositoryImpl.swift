//
//  DailyBudgetRepository.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/12/24.
//

import Foundation
import RxSwift
import RealmSwift


// MARK: - Impl
final class DailyBudgetRepositoryImpl: DailyBudgetRepository {
    
    private let realm = RealmStorage.shared.realm
    
    func read(_ date: Date) -> Observable<DailyBudget?> {
        print("Impl: Read DailyBudget \(date)")
        
        let realmDailyBudgets = realm.objects(RealmDailyBudget.self)
        let realmDailyBudget = realmDailyBudgets.where { $0.date == date.formattedDate }.first
        
        return .just(realmDailyBudget?.toEntity())
    }
    
    func updateHaruby(_ id: String, haruby: Int) -> Observable<Void> {
        print("Impl: Update Haruby \(haruby)")
        
        guard let realmDailyBudget = realm.object(ofType: RealmDailyBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            realmDailyBudget.haruby = haruby
        }
        
        return .just(())
    }
    
    func updateMemo(_ id: String, memo: String) -> Observable<Void> {
        print("Impl: Update Memo \(memo)")
        
        guard let realmDailyBudget = realm.object(ofType: RealmDailyBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            realmDailyBudget.memo = memo
        }
        
        return .just(())
    }
    
    func updateExpense(_ id: String, expense: TransactionRecord) -> Observable<Void> {
        print("Impl: Update Expense \(expense)")
        
        guard let realmDailyBudget = realm.object(ofType: RealmDailyBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            
            if let expense = realmDailyBudget.expense {
                realm.delete(expense.transactionItems)
                realm.delete(expense)
            }
            
            realmDailyBudget.expense = RealmTransactionRecord(expense)
        }
        
        return .just(())
    }
    
    func updateIncome(_ id: String, income: TransactionRecord) -> Observable<Void> {
        print("Impl: Update Income \(income)")
        
        guard let realmDailyBudget = realm.object(ofType: RealmDailyBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            
            if let income = realmDailyBudget.income {
                realm.delete(income.transactionItems)
                realm.delete(income)
            }
            
            realmDailyBudget.income = RealmTransactionRecord(income)
        }
        
        return .just(())
    }
}

// MARK: - Stub
final class StubDailyBudgetRepository: DailyBudgetRepository {
    func read(_ date: Date) -> Observable<DailyBudget?> {
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

//
//  SalaryBudgetRepository.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RxSwift
import RealmSwift

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

// MARK: - Impl
final class SalaryBudgetRepositoryImpl: SalaryBudgetRepository {
    
    private let realm = RealmStorage.shared.realm
    
    func create(_ salaryBudget: SalaryBudget) -> Observable<Void> {
        print("Impl: Create \(salaryBudget)")
        
        try! realm.write {
            let realmSalaryBudget = RealmSalaryBudget(salaryBudget)
            realm.add(realmSalaryBudget)
        }
        
        return .just(())
    }
    
    func fetch() -> Observable<[SalaryBudget]> {
        print("Impl: Fetch SalaryBudget")
        
        let realmSalaryBudgets = realm.objects(RealmSalaryBudget.self)
        let salaryBudgets = realmSalaryBudgets.map { $0.toEntity() }
        
        return .just(Array(salaryBudgets))
    }
    
    func read(_ startDate: Date) -> Observable<SalaryBudget?> {
        print("Impl: Read SalaryBudget \(startDate)")
        
        let realmSalaryBudgets = realm.objects(RealmSalaryBudget.self)
        let salaryBudgets = realmSalaryBudgets.map { $0.toEntity() }
        let salaryBudget = salaryBudgets.first { $0.startDate == startDate.formattedDate }

        return .just(salaryBudget)
    }
    
    func updateDate(_ id: String, start: Date, end: Date) -> Observable<Void> {
        print("Impl: Update Date \(start) - \(end)")
        
        guard let realmSalaryBudget = realm.object(ofType: RealmSalaryBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            realmSalaryBudget.startDate = start.formattedDate
            realmSalaryBudget.endDate = end.formattedDate
        }
        
        return .just(())
    }
    
    func updateFixedIncome(_ id: String, fixedIncome: Int) -> Observable<Void> {
        print("Impl: Update fixedIncome \(fixedIncome)")
        
        guard let realmSalaryBudget = realm.object(ofType: RealmSalaryBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            realmSalaryBudget.fixedIncome = fixedIncome
        }
        
        return .just(())
    }
    
    func updateFixedExpense(_ id: String, fixedExpense: [TransactionItem]) -> Observable<Void> {
        print("Impl: Update fixedExpense \(fixedExpense)")
        
        guard let realmSalaryBudget = realm.object(ofType: RealmSalaryBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        let realmTransactionItems = fixedExpense.map { RealmTransactionItem($0) }
        let listRealmTransactionItem = List<RealmTransactionItem>()
        listRealmTransactionItem.append(objectsIn: realmTransactionItems)
        
        try! realm.write {
            realm.delete(realmSalaryBudget.fixedExpense)
            realmSalaryBudget.fixedExpense = listRealmTransactionItem
        }
        
        return .just(())
    }
    
    func updateBalance(_ id: String, balance: Int) -> Observable<Void> {
        print("Impl: Update Balance \(balance)")
        
        guard let realmSalaryBudget = realm.object(ofType: RealmSalaryBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            realmSalaryBudget.balance = balance
        }
        
        return .just(())
    }
    
    func updateDefaultHaruby(_ id: String, defaultHaruby: Int) -> Observable<Void> {
        print("Impl: Update DefaultHaruby \(defaultHaruby)")
        
        guard let realmSalaryBudget = realm.object(ofType: RealmSalaryBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            realmSalaryBudget.defaultHaruby = defaultHaruby
        }
        
        return .just(())
    }
    
    
    func delete(_ id: String) -> Observable<Void> {
        print("Impl: Delete SalaryBudget")
        
        guard let realmSalaryBudget = realm.object(ofType: RealmSalaryBudget.self, forPrimaryKey: id) else {
            return .just(())
        }
        
        try! realm.write {
            
            realmSalaryBudget.fixedExpense.forEach { realm.delete($0) }
            
            realmSalaryBudget.dailyBudgets.forEach { dailyBudget in
                if let expense = dailyBudget.expense {
                    realm.delete(expense.transactionItems)
                    realm.delete(expense)
                }
                
                if let income = dailyBudget.income {
                    realm.delete(income.transactionItems)
                    realm.delete(income)
                }
                
                realm.delete(dailyBudget)
            }
            
            realm.delete(realmSalaryBudget)
        }
        
        return .empty()
    }
}


// MARK: - Stub
final class StubSalaryBudgetRepository: SalaryBudgetRepository {
    
    func create(_ salaryBudget: SalaryBudget) -> Observable<Void> {
        print("Stub: Create \(salaryBudget)")
        return .empty()
    }
    
    func fetch() -> Observable<[SalaryBudget]> {
        print("Stub: Fetch SalaryBudget")
        return .empty()
    }
    
    func read(_ startDate: Date) -> Observable<SalaryBudget?> {
        print("Stub: Read SalaryBudget \(startDate)")
        return .empty()
    }
    
    func updateDate(_ id: String, start: Date, end: Date) -> Observable<Void> {
        print("Stub: Update Date \(start) - \(end)")
        return .empty()
    }
    
    func updateFixedIncome(_ id: String, fixedIncome: Int) -> Observable<Void> {
        print("Stub: Update fixedIncome \(fixedIncome)")
        return .empty()
    }
    
    func updateFixedExpense(_ id: String, fixedExpense: [TransactionItem]) -> Observable<Void> {
        print("Stub: Update fixedExpense \(fixedExpense)")
        return .empty()
    }
    
    func updateBalance(_ id: String, balance: Int) -> Observable<Void> {
        print("Stub: Update balance \(balance)")
        return .empty()
    }
    
    func updateDefaultHaruby(_ id: String, defaultHaruby: Int) -> Observable<Void> {
        print("Stub: Update defaultHaruby \(defaultHaruby)")
        return .empty()
    }
    
    
    func delete(_ id: String) -> Observable<Void> {
        print("Stub: Delete SalaryBudget")
        return .empty()
    }
}

extension SalaryBudgetRepositoryImpl {
    private func getSalaryBudgetFromKey(id: String) -> RealmSalaryBudget? {
        let realmSalaryBudget = realm.object(ofType: RealmSalaryBudget.self, forPrimaryKey: id)
        return realmSalaryBudget
    }
}

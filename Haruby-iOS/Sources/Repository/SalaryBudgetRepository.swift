//
//  SalaryBudgetRepository.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
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

// MARK: - Impl
final class SalaryBudgetRepositoryImpl: SalaryBudgetRepository {
    
    func create(_ salaryBudget: SalaryBudget) -> Observable<Void> {
        print("Impl: Create \(salaryBudget)")
        return .empty()
    }
    
    func fetch() -> Observable<[SalaryBudget]> {
        print("Impl: Fetch SalaryBudget")
        return .empty()
    }
    
    func read(_ startDate: Date) -> Observable<SalaryBudget?> {
        print("Impl: Read SalaryBudget \(startDate)")
        return .empty()
    }
    
    func updateDate(_ id: String, start: Date, end: Date) -> Observable<Void> {
        print("Impl: Update Date \(start) - \(end)")
        return .empty()
    }
    
    func updateFixedIncome(_ id: String, fixedIncome: Int) -> Observable<Void> {
        print("Impl: Update fixedIncome \(fixedIncome)")
        return .empty()
    }
    
    func updateFixedExpense(_ id: String, fixedExpense: [TransactionItem]) -> Observable<Void> {
        // TODO: 기존 RealmExpenseItem Delete 필요
        print("Impl: Update fixedExpense \(fixedExpense)")
        return .empty()
    }
    
    func updateBalance(_ id: String, balance: Int) -> Observable<Void> {
        print("Impl: Update balance \(balance)")
        return .empty()
    }
    
    func updateDefaultHaruby(_ id: String, defaultHaruby: Int) -> Observable<Void> {
        print("Impl: Update defaultHaruby \(defaultHaruby)")
        return .empty()
    }
    
    
    func delete(_ id: String) -> Observable<Void> {
        print("Impl: Delete SalaryBudget")
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


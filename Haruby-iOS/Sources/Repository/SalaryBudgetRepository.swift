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
    var salaryBudgets: [RealmSalaryBudget] = []
    
    init() {
        self.salaryBudgets.append(StubSalaryBudgetRepository.createMockRealmSalaryBudget())
    }
    
    func create(_ salaryBudget: SalaryBudget) -> Observable<Void> {
        print("Stub: Create SalaryBudget")
        salaryBudgets.append(RealmSalaryBudget(salaryBudget))
        return Observable.just(())
    }
    
    func fetch() -> Observable<[SalaryBudget]> {
        print("Stub: Fetch SalaryBudget")
        return Observable.just(salaryBudgets.map { $0.toEntity() })
    }
    
    func read(_ startDate: Date) -> Observable<SalaryBudget?> {
        print("Stub: Read SalaryBudget \(startDate)")
        let salaryBudget = salaryBudgets.first { $0.startDate == startDate }
        return Observable.just(salaryBudget?.toEntity())
    }
    
    func updateDate(_ id: String, start: Date, end: Date) -> Observable<Void> {
        print("Stub: Update Date \(start) - \(end)")
        return Observable.just(())
    }
    
    func updateFixedIncome(_ id: String, fixedIncome: Int) -> Observable<Void> {
        print("Stub: Update fixedIncome \(fixedIncome)")
        return Observable.just(())
    }
    
    func updateFixedExpense(_ id: String, fixedExpense: [TransactionItem]) -> Observable<Void> {
        print("Stub: Update fixedExpense \(fixedExpense)")
        return Observable.just(())
    }
    
    func updateBalance(_ id: String, balance: Int) -> Observable<Void> {
        print("Stub: Update balance \(balance)")
        return Observable.just(())
    }
    
    func updateDefaultHaruby(_ id: String, defaultHaruby: Int) -> Observable<Void> {
        print("Stub: Update defaultHaruby \(defaultHaruby)")
        return Observable.just(())
    }
    
    func delete(_ id: String) -> Observable<Void> {
        print("Stub: Delete SalaryBudget")
        return Observable.just(())
    }
}

extension StubSalaryBudgetRepository {
    static func createMockRealmSalaryBudget() -> RealmSalaryBudget {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 10, day: 14))!
        let endDate = calendar.date(from: DateComponents(year: 2024, month: 11, day: 13))!
        
        let fixedExpenses = List<RealmTransactionItem>()
        fixedExpenses.append(objectsIn: [
            RealmTransactionItem(id: UUID().uuidString, name: "월세", price: 500000),
            RealmTransactionItem(id: UUID().uuidString, name: "통신비", price: 50000),
            RealmTransactionItem(id: UUID().uuidString, name: "구독서비스", price: 30000)
        ])
        
        let dailyBudgets = List<RealmDailyBudget>()
        var currentDate = startDate
        while currentDate <= endDate {
            let emptyTransactionItems = List<RealmTransactionItem>()
            let expense = RealmTransactionRecord(id: UUID().uuidString, total: 40000, transactionItems: emptyTransactionItems)
            let income = RealmTransactionRecord(id: UUID().uuidString, total: 0, transactionItems: emptyTransactionItems)
            
            let dailyBudget = RealmDailyBudget(
                id: UUID().uuidString,
                date: currentDate,
                haruby: 50000,
                memo: "",
                expense: expense,
                income: income
            )
            dailyBudgets.append(dailyBudget)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return RealmSalaryBudget(
            id: UUID().uuidString,
            startDate: startDate,
            endDate: endDate,
            fixedIncome: 3000000,
            fixedExpense: fixedExpenses,
            balance: 2420000,
            defaultHaruby: 20000,
            dailyBudgets: dailyBudgets
        )
    }

}

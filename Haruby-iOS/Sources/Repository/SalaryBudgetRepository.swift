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
    func update(_ salaryBudget: SalaryBudget) -> Observable<Void>
    func delete(_ salaryBudget: SalaryBudget) -> Observable<Void>
}


// MARK: - Stub
final class StubSalaryBudgetRepository: SalaryBudgetRepository {
    func create(_ salaryBudget: SalaryBudget) -> Observable<Void> {
        Observable.create { observer in
            print("Stub: Create SalaryBudget")
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func fetch() -> Observable<[SalaryBudget]> {
        Observable.create { observer in
            print("Stub: Fetch SalaryBudget")
            observer.onNext(([]))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func read(_ startDate: Date) -> Observable<SalaryBudget?> {
        Observable.create { observer in
            print("Stub: Read SalaryBudget \(startDate)")
            observer.onNext((nil))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func update(_ salaryBudget: SalaryBudget) -> Observable<Void> {
        Observable.create { observer in
            print("Stub: Update SalaryBudget")
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func delete(_ salaryBudget: SalaryBudget) -> Observable<Void> {
        Observable.create { observer in
            print("Stub: Delete SalaryBudget")
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
}


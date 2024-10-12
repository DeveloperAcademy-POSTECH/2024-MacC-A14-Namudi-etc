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
}

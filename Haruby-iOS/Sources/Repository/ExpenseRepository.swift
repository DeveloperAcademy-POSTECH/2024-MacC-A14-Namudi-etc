//
//  ExpenseRepository.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/12/24.
//

import Foundation
import RxSwift

// 수입 지출 Repository
protocol ExpenseRepository {
    func updateIncome(_ id: String, total: Int, expenseItem: [ExpenseItem]) -> Observable<Void>
    func updateExpense(_ id: String, total: Int, incomeItem: [ExpenseItem]) -> Observable<Void>
}

// MARK: - Stub
final class StubExpenseRepository: ExpenseRepository {
    func updateIncome(_ id: String, total: Int, expenseItem: [ExpenseItem]) -> Observable<Void> {
        print("Stub: Update Income total - \(total), expenseItem - \(expenseItem)")
        return .empty()
    }
    
    func updateExpense(_ id: String, total: Int, incomeItem: [ExpenseItem]) -> Observable<Void> {
        print("Stub: Update Income total - \(total), expenseItem - \(incomeItem)")
        return .empty()
    }
}

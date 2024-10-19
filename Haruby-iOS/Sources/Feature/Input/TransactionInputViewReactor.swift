//
//  InputViewReactor.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/13/24.
//

import UIKit
import ReactorKit
import RxSwift

final class TransactionInputViewReactor: Reactor {
    enum Action {
        case transactionTypeButtonTapped(TransactionType)
        case datePickerTapped
        case totalPriceTextFieldEditting(String)
        case detailButtonTapped
        case addingTransactionButtonTapped
        case deletingTransactionButtonTapped(IndexPath)
    }
    
    enum Mutation {
        case setTransactionType(TransactionType)
        case setDatePickerVisible(Bool)
        case setTransactionPrice(Int)
        case setDetailVisible(Bool)
        case addDetailTransaction
        case deleteDetailTransaction
    }
    
    struct State {
        var isDetailVisible: Bool = false
        var isDatePickerVisible: Bool = false
        var transactionType: TransactionType = .expense
        var dailyBudget: DailyBudget
        var isTextFieldEditting: Bool = false
    }
    
    var initialState: State
    
    init(dailyBudget: DailyBudget) {
        self.initialState = State(dailyBudget: dailyBudget)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .detailButtonTapped:
            let isDetailVisible = !currentState.isDetailVisible
            return Observable.just(.setDetailVisible(isDetailVisible))
            
        case .datePickerTapped:
            let isDatePickerVisible = !currentState.isDatePickerVisible
            return Observable.just(.setDatePickerVisible(isDatePickerVisible))
            
        case .transactionTypeButtonTapped(let newType):
            return Observable.just(.setTransactionType(newType))
            
        case .addingTransactionButtonTapped:
            return Observable.just(.addDetailTransaction)
        case .totalPriceTextFieldEditting(let text):
            return updateTotalPrice(text)
        case .deletingTransactionButtonTapped(_):
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        let currentTransactionType = currentState.transactionType
        
        switch mutation {
        case let .setDetailVisible(isVisible):
            newState.isDetailVisible = isVisible
            
        case let .setDatePickerVisible(isVisible):
            newState.isDatePickerVisible = isVisible
            
        case let .setTransactionType(type):
            newState.transactionType = type
            
        case .addDetailTransaction:
            if currentTransactionType == .expense {
                newState.dailyBudget.expense.transactionItems.append(.init(name: "", price: 0))
            } else {
                newState.dailyBudget.income.transactionItems.append(.init(name: "", price: 0))
            }
        case .setTransactionPrice(let price):
            if currentTransactionType == .expense {
                newState.dailyBudget.expense.total = price
            } else {
                newState.dailyBudget.income.total = price
            }
            newState.isTextFieldEditting.toggle()
        case .deleteDetailTransaction:
            break
        }
        
        return newState
    }
}

extension TransactionInputViewReactor {
    private func updateTotalPrice(_ text: String) -> Observable<Mutation> {
        let beforeText = currentState.transactionType == .expense
        ? currentState.dailyBudget.expense.total.decimalWithWon
        : currentState.dailyBudget.income.total.decimalWithWon
        
        return .just(.setTransactionPrice(
            beforeText.count < text.count
            ? text.numberFormat! // 입력된 경우
            : String(text.dropLast()).numberFormat ?? 0 // 삭제한 경우
        ))
    }
}

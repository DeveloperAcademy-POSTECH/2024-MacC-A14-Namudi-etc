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
        case amountTextFieldEditting(String)
        case detailButtonTapped
        case addingTransactionButtonTapped
        case deletingTransactionButtonTapped(IndexPath)
    }
    
    enum Mutation {
        case setTransactionType(TransactionType)
        case setDatePickerVisible(Bool)
        case setAmountTextFieldText(String)
        case setDetailVisible(Bool)
        case addDetailTransaction
        case deleteDetailTransaction
    }
    
    struct State {
        var isDetailVisible: Bool = false
        var isDatePickerVisible: Bool = false
        var transactionType: TransactionType = .expense
        var dailyBudget: DailyBudget
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
        case .amountTextFieldEditting(let text):
            return .just(.setAmountTextFieldText(text))
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
        case .setAmountTextFieldText(let text):
            if currentTransactionType == .expense {
                newState.dailyBudget.expense.total = text.numberFormat ?? 0
            } else {
                newState.dailyBudget.income.total = text.numberFormat ?? 0
            }
        case .deleteDetailTransaction:
            break
        }
        
        return newState
    }
}

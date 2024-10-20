//
//  HarubyEditViewReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/12/24.
//

import ReactorKit
import RxSwift
import Foundation

final class HarubyEditViewReactor: Reactor {
    enum Action {
        case editHarubyText(String)
        case editMemoText(String)
        case bottomButtonTapped
    }
    
    enum Mutation {
        case setHaruby(Int)
        case setHarubyText(String)
        case setMemoText(String)
        case setNewBalance(Int)
        case allUpdatesSuccess(Bool)
    }
    
    struct State {
        var salaryBudget: SalaryBudget
        var dailyBudget: DailyBudget
        var haruby = 0
        var harubyText = ""
        var memoText = ""
        var savedSuccessfully = false
    }
    
    let initialState: State
    
    let salaryBudgetRepository: SalaryBudgetRepository
    let dailyBudgetRepository: DailyBudgetRepository
    
    init(salaryBudget: SalaryBudget, dailyBudget: DailyBudget){
        self.initialState = State(salaryBudget: salaryBudget,
                                  dailyBudget: dailyBudget,
                                  memoText: dailyBudget.memo)
        
        guard let salaryBudgetRepository = DIContainer.shared.resolve(SalaryBudgetRepository.self) else {
            fatalError("SalaryBudgetRepository is not registered.")
        }
        guard let dailyBudgetRepository = DIContainer.shared.resolve(DailyBudgetRepository.self) else {
            fatalError("DailyBudgetRepository is not registered.")
        }
        
        
        self.salaryBudgetRepository = salaryBudgetRepository
        self.dailyBudgetRepository = dailyBudgetRepository
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .editHarubyText(let harubyText):
            let (harubyNumber, newText) = processHarubyText(harubyText)
            
            let setHaruby = Observable.just(Mutation.setHaruby(harubyNumber))
            let setHarubyText = Observable.just(Mutation.setHarubyText(newText))
            
            return Observable.concat([setHaruby, setHarubyText])
            
        case .editMemoText(let memoText):
            let prefixedText = String(memoText.prefix(30))
            return Observable.just(.setMemoText(prefixedText))
            
        case .bottomButtonTapped:
            let salaryBudgetId = self.currentState.salaryBudget.id
            let dailyBudgetId = self.currentState.dailyBudget.id
            
            let newHaruby = self.currentState.haruby
            let oldHaruby = self.currentState.dailyBudget.haruby ?? self.currentState.salaryBudget.defaultHaruby
            let newMemo = self.currentState.memoText
            
            let newDefaultHaruby = getDefaultHaruby(salaryBudget: self.currentState.salaryBudget,
                                                    newHaruby: newHaruby,
                                                    oldHaruby: oldHaruby)
            
            let updateDailyBudgetHaruby = dailyBudgetRepository.updateHaruby(dailyBudgetId, haruby: newHaruby)
            let updateDailyBudgetMemo = dailyBudgetRepository.updateMemo(dailyBudgetId, memo: newMemo)
            let updateDefaultHaruby = salaryBudgetRepository.updateDefaultHaruby(salaryBudgetId, defaultHaruby: newDefaultHaruby)
            
            let allUpdates = performAllUpdates(
                harubyUpdate: updateDailyBudgetHaruby,
                memoUpdate: updateDailyBudgetMemo,
                defaultHarubyUpdate: updateDefaultHaruby
            )
            
            return Observable.concat([allUpdates])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setHaruby(let haruby):
            newState.haruby = haruby
        case .setHarubyText(let harubyText):
            newState.harubyText = harubyText
        case .setMemoText(let memoText):
            newState.memoText = memoText
        case .setNewBalance(let newBalance):
            newState.salaryBudget.balance = newBalance
        case .allUpdatesSuccess(let saveSuccess):
            newState.savedSuccessfully = saveSuccess
        }
        return newState
    }
    
    // MARK: - Private Methods
    private func processHarubyText(_ harubyText: String) -> (Int, String) {
        var harubyNumber = 0
        var newText = ""
        
        if harubyText.isEmpty || harubyText == "원" {
            newText = ""
        } else {
            harubyNumber = harubyText.numberFormat ?? 0
            newText = harubyNumber.decimalWithWon
        }
        
        return (harubyNumber, newText)
    }
    
    private func calculateNewBalance(newHaruby: Int, oldHaruby: Int, currentBalance: Int) -> Int {
        return currentBalance - (newHaruby - oldHaruby)
    }
    
    private func performAllUpdates(harubyUpdate: Observable<Void>, memoUpdate: Observable<Void>, defaultHarubyUpdate: Observable<Void>) -> Observable<Mutation> {
        return Observable.zip(harubyUpdate, memoUpdate, defaultHarubyUpdate)
            .flatMap { _ in Observable.just(Mutation.allUpdatesSuccess(true)) }
    }
    
    private func getDefaultHaruby(salaryBudget: SalaryBudget, newHaruby: Int, oldHaruby: Int) -> Int {
        let harubyDifference = oldHaruby - newHaruby
        
        var nilCount = 0
        let now = Date().formattedDate
        
        for dailyBudget in salaryBudget.dailyBudgets {
            if dailyBudget.date >= now && dailyBudget.haruby == nil {
                nilCount += 1
            }
        }
        
        return nilCount == 0 ? salaryBudget.defaultHaruby : harubyDifference / (nilCount - 1) + salaryBudget.defaultHaruby
    }
}

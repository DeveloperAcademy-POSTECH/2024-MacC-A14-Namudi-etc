//
//  HarubyEditViewReactor.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/12/24.
//

import ReactorKit
import RxSwift

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
        case calculateDefaultHaruby(SalaryBudget)
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
        // TODO: SalaryBudget의 default하루비 가져오기
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
            let newBalance = calculateNewBalance(newHaruby: newHaruby, oldHaruby: oldHaruby, currentBalance: self.currentState.salaryBudget.balance)
            let newMemo = self.currentState.memoText
            
            let setNewBalance = Observable.just(Mutation.setNewBalance(newBalance))
            let calculateDefaultHaruby = Observable.just(Mutation.calculateDefaultHaruby(self.currentState.salaryBudget))
            
            let updateDailyBudgetHaruby = dailyBudgetRepository.updateHaruby(dailyBudgetId, haruby: newHaruby)
            let updateDailyBudgetMemo = dailyBudgetRepository.updateMemo(dailyBudgetId, memo: newMemo)
            let updateBalance = salaryBudgetRepository.updateBalance(salaryBudgetId, balance: newBalance)
            let updateDefaultHaruby = salaryBudgetRepository.updateDefaultHaruby(salaryBudgetId, defaultHaruby: self.currentState.salaryBudget.defaultHaruby)
            
            let allUpdates = performAllUpdates(
                harubyUpdate: updateDailyBudgetHaruby,
                memoUpdate: updateDailyBudgetMemo,
                balanceUpdate: updateBalance,
                defaultHarubyUpdate: updateDefaultHaruby
            )
            
            // 상태 업데이트와 비동기 업데이트의 결합
            return Observable.concat([setNewBalance, calculateDefaultHaruby, allUpdates])
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
        case .calculateDefaultHaruby(let salaryBudget):
            let newDefaultHaruby = HarubyCalculateManager.getDefaultHarubyFromNow(salaryBudget: salaryBudget)
            newState.salaryBudget.defaultHaruby = newDefaultHaruby
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
    
    private func performAllUpdates(harubyUpdate: Observable<Void>, memoUpdate: Observable<Void>, balanceUpdate: Observable<Void>, defaultHarubyUpdate: Observable<Void>) -> Observable<Mutation> {
        return Observable.zip(harubyUpdate, memoUpdate, balanceUpdate, defaultHarubyUpdate)
            .flatMap { _ in Observable.just(Mutation.allUpdatesSuccess(true)) }
    }
}

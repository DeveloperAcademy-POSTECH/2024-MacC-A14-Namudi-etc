//
//  WidgetManager.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/21/24.
//

import Foundation


struct WidgetManager {
  
  static let shared = WidgetManager()
  
  private init() {
    let storageProvider = StorageProvider()
    let repositoryProvider = RepositoryProvider(storageProvider: storageProvider)
    
    self.budgetUseCase = BudgetUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      dailyBudgetRepository: repositoryProvider.dailyBudgetRepository,
      userDefaultsRepository: repositoryProvider.userDefaltsRepository
    )
  }
  
  private let budgetUseCase: BudgetUseCase
  
  func fetchCurrentSalaryBudget() -> SalaryBudget? {
    do {
      let now = Date().formattedDate
      return try budgetUseCase.getCurrentSalaryBudget(date: now)
    } catch {
      return nil
    }
  }
  
  func getDailyStreak(_ salaryBudget: SalaryBudget) -> [DailyStreak] {
    var dailyStreak: [DailyStreak] = []
    
    let index = salaryBudget.dailyBudgets.firstIndex { dailyBudget in
      dailyBudget.date == .now.formattedDate
    } ?? salaryBudget.dailyBudgets.count
    
    for i in 0..<DailyStreak.count {
      if index + i > salaryBudget.dailyBudgets.count - 1 {
        dailyStreak.append(.init(
          date: nil,
          time: .future,
          harubee: nil
        ))
      } else {
        let dailyBudget = salaryBudget.dailyBudgets[index + i]
        
        let date = dailyBudget.date
        let time: DailyStreak.Time = date == .now.formattedDate
        ? .today : .future
        let harubee = dailyBudget.harubee ?? Int(salaryBudget.defaultHarubee)
        let isAdjustedHarubee = dailyBudget.harubee != nil ? true : false
        let expenseType: DailyStreak.ExpenseType = {
          guard let expense = dailyBudget.expense,
                let income = dailyBudget.income else { return .empty }
          
          let result = harubee - expense + income
          return result >= 0 ? .good : .bad
        }()
        
        dailyStreak.append(DailyStreak(
          date: date,
          time: time,
          harubee: harubee,
          isAdjustedHarubee: isAdjustedHarubee,
          expenseType: expenseType
        ))
      }
    }
    
    return dailyStreak
  }
}

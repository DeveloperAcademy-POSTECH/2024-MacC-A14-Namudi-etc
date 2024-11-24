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
    self.salaryBudgetRepository = SalaryBudgetRepositoryImpl(
      modelContext: StorageProvider().modelContext
    )
  }
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  
  func fetchCurrentSalaryBudget() -> SalaryBudget? {
    do {
      let salaryBudgets = try salaryBudgetRepository.readAll()
      
      let now = Date().formattedDate
      let currentSalaryBudget = salaryBudgets.first(where: {
        $0.startDate <= now && $0.endDate >= now
      }) ?? salaryBudgets.last
      
      return currentSalaryBudget
    } catch {
      return nil
    }
  }
  
  func getDailyStreak(_ salaryBudget: SalaryBudget?) -> [DailyStreak] {
    var dailyStreak: [DailyStreak] = []
    
    // SalaryBudget이 없거나, 
    guard let salaryBudget = salaryBudget,
          let index = salaryBudget.dailyBudgets.firstIndex(where: {
            $0.date == .now.formattedDate
          }) else {
      return []
    }
    
    for i in 0..<6 {
    
      if index > salaryBudget.dailyBudgets.count - 1 {
//        dailyStreak.append(nil)
        continue
      }
      
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
    
    return dailyStreak
  }
}

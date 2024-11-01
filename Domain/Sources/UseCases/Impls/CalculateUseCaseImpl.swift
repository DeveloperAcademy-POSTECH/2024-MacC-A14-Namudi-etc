//
//  CalculateUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class CalculateUseCaseImpl: CalculateUseCase {
  
  private let calendar: Calendar
  
  public init(calendar: Calendar = .current) {
    self.calendar = calendar
  }
  
  public func calculateDefaultHarubee(salaryBudget: SalaryBudget) throws -> Double {
    
    let currentDate = calendar.date(
      from:calendar.dateComponents(
        [.year, .month, .day],
        from: Date()
      )
    )!
    var nilCount = 0.0
    var newBalance = Double(salaryBudget.balance)
    
    for dailyBudget in salaryBudget.dailyBudgets {
      if dailyBudget.date < currentDate { continue }
      
      if let harubee = dailyBudget.harubee { newBalance -= Double(harubee) }
      else { nilCount += 1 }
    }
    
    return nilCount == 0.0 ? newBalance : newBalance / nilCount
  }
  
  public func calculateAverageHarubee(endDate: Date, balance: Int) throws -> Double {
    let currentDate = calendar.date(
      from:calendar.dateComponents(
        [.year, .month, .day],
        from: Date()
      )
    )!
    let secondsInDay = 86400.0
    let remain = endDate.timeIntervalSince(currentDate) / secondsInDay + 1
    
    return Double(balance) / remain
  }
}

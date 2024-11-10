//
//  TodayViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

struct DailyStreak {
  let date: Date
  let isAfterToday: Bool
  let harubee: Int
  let isOverHarubee: Bool?
}

@Observable
final class TodayViewModel {
  // MARK: - State
  struct State {
    var todayDate = Date()
    var todayHarubee = 0
    var averageHarubee = 0
    var todayHarubeePercentage: Double = 0.0
    var todayAverageHarubeePercentage: Double = 0.0
    var weeklyStreaks: [DailyStreak]?
    
    var salaryBudget: SalaryBudget?
    var todayDailyBudget: DailyBudget?
  }
  
  // MARK: - Action
  enum Action {
    case viewDidLoad
  }
  
  private let budgetUseCase: BudgetUseCase
  private(set) var state: State = .init()
  
  init(budgetUseCase: BudgetUseCase) {
    self.budgetUseCase = budgetUseCase
  }
  
  
  // MARK: - Send
  func send(_ action: Action) {
    switch action {
    case .viewDidLoad:
      print(#function)
      fetchSalaryBudget()
    }
  }
}

extension TodayViewModel {
  // MARK: - Private Function
  private func fetchSalaryBudget() {

    do {
      // 1. 오늘날짜가 포함되는 SalaryBudget을 가져오기
      let salaryBudget = try budgetUseCase.getCurrentSalaryBudget(date: state.todayDate)
      
      initializeState(salaryBudget: salaryBudget)
      
    } catch DomainError.dataNotFound {
      
      // 2. 없다면 가장 최근 SalaryBudget을 기반으로 새 SalaryBudget 생성
      let salaryBudgets = try? budgetUseCase.getAllSalaryBudget()

      guard let recentSalaryBudget = salaryBudgets?.max(by: { $0.endDate < $1.endDate }) else { return }
      
      // 3. 새로운 시작일과 종료일 계산
      let (newStartDate, newEndDate) = calculateNewSalaryBudgetDates(
        referenceStartDay: Calendar.current.component(.day, from: recentSalaryBudget.startDate),
        today: Calendar.current.component(.day, from: state.todayDate)
      )
      
      // 4. 새로운 SalaryBudget 생성
      if let newSalaryBudget = try? budgetUseCase.createSalaryBudget(
        startDate: newStartDate,
        endDate: newEndDate,
        previousExpense: nil,
        fixedIncome: recentSalaryBudget.fixedIncome,
        fixedExpenses: recentSalaryBudget.fixedExpenses
      ) {
        initializeState(salaryBudget: newSalaryBudget)
      }
    } catch {
      print("other error: \(error)")
    }
  }
  
  private func calculateNewSalaryBudgetDates(referenceStartDay: Int, today: Int) -> (Date, Date) {
    let calendar = Calendar.current
    
    if today < referenceStartDay {
      let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: state.todayDate)!
      let newStartDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: previousMonthDate),
                                                            month: calendar.component(.month, from: previousMonthDate),
                                                            day: referenceStartDay))!
      
      let newEndDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: state.todayDate),
                                                          month: calendar.component(.month, from: state.todayDate),
                                                          day: referenceStartDay - 1))!
      
      return (newStartDate, newEndDate)
      
    } else {
      let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: state.todayDate)!
      let newStartDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: state.todayDate),
                                                            month: calendar.component(.month, from: state.todayDate),
                                                            day: referenceStartDay))!
      
      let newEndDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: nextMonthDate),
                                                          month: calendar.component(.month, from: nextMonthDate),
                                                          day: referenceStartDay - 1))!
      
      return (newStartDate, newEndDate)
    }
  }
  
  private func initializeState(salaryBudget: SalaryBudget) {
    state.salaryBudget = salaryBudget
    
    let currentEndDate = salaryBudget.endDate
    let currentBalance = salaryBudget.balance
    let todayDailyBudget = salaryBudget.dailyBudgets.first(where: { $0.date == state.todayDate.formattedDate })
    
    let todayHarubee = todayDailyBudget?.harubee ?? Int(salaryBudget.defaultHarubee)
    let averageHarubee = Int(budgetUseCase.calculateAverageHarubee(endDate: currentEndDate,
                                                                         balance: currentBalance))
    let weeklyStreaks = getWeeklyStreaks(salaryBudget: salaryBudget)
    let todayHarubeePercentage = todayDailyBudget?.expense == nil ? 1.0 : Double((todayDailyBudget?.expense)! / todayHarubee)
    let originalAverageHarubee = Double(salaryBudget.fixedIncome / 30)
    let todayAverageHarubeePercentage = Double(averageHarubee) / originalAverageHarubee
    
    state.todayHarubee = todayHarubee
    state.averageHarubee = averageHarubee
    state.weeklyStreaks = weeklyStreaks
    
    state.todayDailyBudget = todayDailyBudget
    state.todayHarubeePercentage = todayHarubeePercentage
    state.todayAverageHarubeePercentage = todayAverageHarubeePercentage / 2
  }
  
  private func getWeeklyStreaks(salaryBudget: SalaryBudget) -> [DailyStreak] {
    let calendar = Calendar.current
    let today = state.todayDate
    
    // 오늘 기준 7일 범위 설정 (앞 3일, 오늘, 뒤 3일)
    guard let startDate = calendar.date(byAdding: .day, value: -3, to: today),
          let endDate = calendar.date(byAdding: .day, value: 3, to: today)
    else {
      return []
    }
    
    var weeklyStreaks = [DailyStreak]()
    var currentDate = startDate
    
    // 각 날짜에 대해 DailyBudget을 가져오거나, 없으면 임의로 생성하여 추가
    while currentDate <= endDate {
      do {
        
        let dailyBudget = try budgetUseCase.getDailyBudget(date: currentDate)
        
        let harubee = dailyBudget.harubee == nil ? Int(salaryBudget.defaultHarubee) : dailyBudget.harubee
        let isOverHarubee = dailyBudget.expense == nil ? nil : (dailyBudget.expense! <= harubee!)
        
        let newDailyStreak = DailyStreak(date: currentDate,
                                         isAfterToday: currentDate > today,
                                         harubee: harubee!,
                                         isOverHarubee: isOverHarubee)
        
        weeklyStreaks.append(newDailyStreak)
        
      } catch DomainError.dataNotFound {
        
        let nextStartDate = calendar.date(byAdding: .month, value: 1, to: salaryBudget.startDate)!
        let nextEndDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: nextStartDate)!

        let nextSalaryBudgetDays = calendar.dateComponents([.day], from: nextStartDate, to: nextEndDate).day!
        
        let harubee = salaryBudget.fixedIncome / nextSalaryBudgetDays
        
        let newDailyStreak = DailyStreak(date: currentDate,
                                         isAfterToday: currentDate > today,
                                         harubee: harubee,
                                         isOverHarubee: nil)
        
        weeklyStreaks.append(newDailyStreak)
        
      } catch {
        print("other error: \(error)")
      }
      
      // 다음 날로 이동
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    // 최종적으로 정렬하여 반환
    return weeklyStreaks
  }
  
}

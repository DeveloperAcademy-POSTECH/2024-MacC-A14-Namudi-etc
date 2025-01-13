//
//  TodayViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct DailyStreak {
  let date: Date
  let isAfterToday: Bool
  let harubee: Int
  let isHarubeeAdjusted: Bool
  let isOverHarubee: Bool?
}

@Observable
final class TodayViewModel {
  // MARK: - State
  struct State {
    var todayDate = Date()
    var todayHarubee = 0
    var nextIncomeDate: Date = Date()
    var todayHarubeePercentage: Double = 0.0
    var todayBalance: Int = 0
    var todayBalancePercentage: Double = 0.0
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
      self.state.todayDate = .now
      fetchSalaryBudget()
    }
  }
}

extension TodayViewModel {
  // MARK: - Private Function
  private func fetchSalaryBudget() {

    do {
      // 1. 오늘날짜가 포함되는 SalaryBudget을 가져오기
      let salaryBudget = try budgetUseCase.getCurrentSalaryBudget(
        date: state.todayDate
      )
      
      initializeState(salaryBudget: salaryBudget)
      
    } catch DomainError.dataNotFound {
      
      // 3. 없다면 가장 최근 SalaryBudget을 기반으로 새 SalaryBudget 생성
      let salaryBudgets = try? budgetUseCase.getAllSalaryBudget()

      guard let recentSalaryBudget = salaryBudgets?.max(
        by: { $0.endDate < $1.endDate }
      ) else { return }
      
      // 4. 새로운 시작일과 종료일 계산
      var incomeDay = budgetUseCase.getIncomeDay()
      
      // 온보딩이 끝날 때 수입일을 저장해야하는걸 까먹고 못했습니다..
      // 그래서 UserDefaults에 nil로 저장이 돼있을 수 있기 때문에 다음과 같은 코드를 추가했습니다.
      // 현재는 추가된 상태이고, 따라서 2월쯤에는 아래 코드는 지워도 될 거 같습니다.
      if incomeDay == nil {
        budgetUseCase.setIncomeDay(day: recentSalaryBudget.startDate.day)
        incomeDay = recentSalaryBudget.startDate.day
      }
      
      let (newStartDate, newEndDate) = Date.calculateStartAndEndDate(
        from: incomeDay!,
        anchor: .now
      )
      
      // 5. 새로운 수입일에 맞춰 고정 지출 날짜 새롭게 계산
      let newFixedExpenses = recentSalaryBudget.fixedExpenses.map {
        let date = Date.convertDateBetweenStartAndEnd(
          start: newStartDate,
          end: newEndDate,
          day: $0.day
        )
        return TransactionItem(
          date: date,
          day: $0.day,
          name: $0.name,
          price: $0.price
        )
      }
      
      // 6. 새로운 SalaryBudget 생성
      if let newSalaryBudget = try? budgetUseCase.createSalaryBudget(
        startDate: newStartDate,
        endDate: newEndDate,
        currentBalance: nil,
        fixedIncome: recentSalaryBudget.fixedIncome,
        fixedExpenses: newFixedExpenses
      ) {
        initializeState(salaryBudget: newSalaryBudget)
      }
    } catch {
      print("other error: \(error)")
    }
  }
  
  private func initializeState(salaryBudget: SalaryBudget) {
    let calendar = Calendar.current

    let currentBalance = salaryBudget.balance
    let currentFixedIncome = salaryBudget.fixedIncome
    let todayDailyBudget = salaryBudget.dailyBudgets.first(
      where: { $0.date == state.todayDate.formattedDate }
    )
    let nextIncomeDate = calendar.date(
      byAdding: .day, value: 1, to: salaryBudget.endDate
    )!
    let todayExpense = todayDailyBudget?.expense ?? .zero
    let todayHarubee = (
      todayDailyBudget?.harubee ?? Int(salaryBudget.defaultHarubee)
    )
    
    let remainTodayHarubee = todayHarubee - todayExpense
    let weeklyStreaks = getWeeklyStreaks(salaryBudget: salaryBudget)
    let todayHarubeePercentage = todayExpense == .zero
        ? 1.0
        : Double(remainTodayHarubee) / Double(todayHarubee)

    
    state.salaryBudget = salaryBudget
    state.todayDailyBudget = todayDailyBudget
    state.todayHarubee = remainTodayHarubee
    state.todayBalance = currentBalance
    state.nextIncomeDate = nextIncomeDate
    state.weeklyStreaks = weeklyStreaks
    state.todayHarubeePercentage = todayHarubeePercentage
    state.todayBalancePercentage = (
      Double(currentBalance) / Double(currentFixedIncome)
    )
  }
  
  private func getWeeklyStreaks(salaryBudget: SalaryBudget) -> [DailyStreak] {
    let calendar = Calendar.current
    let today = state.todayDate
    
    guard let startDate = today.adding(by: .day, value: -3),
          let endDate = today.adding(by: .day, value: 3)
    else {
      return []
    }
    
    var weeklyStreaks = [DailyStreak]()
    var currentDate = startDate
    
    while currentDate <= endDate {
      do {
        
        let dailyBudget = try budgetUseCase.getDailyBudget(date: currentDate)
        
        let harubee = dailyBudget.harubee ?? Int(salaryBudget.defaultHarubee)
        
        let isOverHarubee = dailyBudget.expense == nil
            ? nil
            : (dailyBudget.expense! > harubee)
        
        let newDailyStreak = DailyStreak(
          date: currentDate,
          isAfterToday: currentDate > today,
          harubee: harubee,
          isHarubeeAdjusted: dailyBudget.harubee != nil,
          isOverHarubee: isOverHarubee
        )
        
        weeklyStreaks.append(newDailyStreak)
        
      } catch DomainError.dataNotFound {
        
        let nextStartDate = calendar.date(
          byAdding: .month,
          value: 1,
          to: salaryBudget.startDate
        )!
        
        let nextEndDate = calendar.date(
          byAdding: DateComponents(month: 1, day: -1),
          to: nextStartDate
        )!

        let nextSalaryBudgetDays = nextStartDate.daysUntil(nextEndDate)
        
        let harubee = salaryBudget.fixedIncome / nextSalaryBudgetDays
        
        let newDailyStreak = DailyStreak(
          date: currentDate,
          isAfterToday: currentDate > today,
          harubee: harubee,
          isHarubeeAdjusted: false,
          isOverHarubee: nil
        )
        
        weeklyStreaks.append(newDailyStreak)
        
      } catch {
        print("other error: \(error)")
      }
      
      currentDate = currentDate.adding(by: .day, value: 1)!
    }
    
    return weeklyStreaks
  }
}

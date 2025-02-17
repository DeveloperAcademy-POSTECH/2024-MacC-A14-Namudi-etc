//
//  SaveOnboardingDataUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

final class SaveOnboardingDataUseCaseImpl: SaveOnboardingDataUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let userDefaultsRepository: UserDefaultsRepository
  
  init(
    salaryBudgetRepository: SalaryBudgetRepository,
    userDefaultsRepository: UserDefaultsRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.userDefaultsRepository = userDefaultsRepository
  }
  
  func execute(
    startDate: Date,
    endDate: Date,
    currentBalance: Int,
    fixedIncomeDay: Int,
    fixedIncomeAmount: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget {
    // 1. date 포멧 변경
    let startDate = startDate.formattedDate
    let endDate = endDate.formattedDate
    
    // 2. 고정 수입일 저장
    userDefaultsRepository.saveIncomeDay(fixedIncomeDay)
    
    // 3. SalaryBudget 생성하기
    let salaryBudget = initializeSalaryBudget(
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncomeAmount,
      fixedExpenses: fixedExpenses,
      balance: currentBalance
    )
    
    // 4. Repository에 저장하기
    salaryBudgetRepository.create(salaryBudget)
    
    // TODO: 다음달 SalaryBudget 생성 시점 생각하기 (온보딩에서 바로 처리 or 홈화면에서 기존 createNextSalaryBudgetIfNeeded() 호출할지
    
    return salaryBudget
  }
}

private extension SaveOnboardingDataUseCaseImpl {
  /// 초기 SalaryBudget을 생성합니다
  /// - Parameters:
  ///   - startDate: 시작 날짜
  ///   - endDate: 종료 날짜
  ///   - fixedIncome: 고정 수입
  ///   - fixedExpenses: 고정 지출 내역
  ///   - balance: 계산된 현재 잔액
  /// - Returns: SalaryBudget
  func initializeSalaryBudget(
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem],
    balance: Int
  ) -> SalaryBudget {
    // 남은 기간의 일자 개수 구하기
    // 온보딩 : 오늘부터, 메인 : 시작 날짜부터
    let today = Date().formattedDate
    let days = today.daysUntil(endDate)
    
    // 고정 지출 금액 뺀 잔액 구하기
    let initialBalance = calculateInitialBalance(
      current: balance,
      items: fixedExpenses
    )
    
    // 기본 하루비 구하기
    let defaultHarubee = Double(initialBalance) / Double(days + 1)
    
    // DailyBudgets 생성
    let dailyBudgets = initializeDailyBudgets(
      startDate: startDate,
      endDate: endDate
    )
    
    // SalaryBudget 생성
    return SalaryBudget(
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncome,
      fixedExpenses: fixedExpenses,
      balance: initialBalance,
      defaultHarubee: defaultHarubee,
      dailyBudgets: dailyBudgets
    )
  }
  
  /// SalaryBudget에 들어갈 초기 DailyBudgets을 생성합니다
  /// - Parameters:
  ///   - startDate: 시작 날짜
  ///   - endDate: 종료 날짜
  /// - Returns: [DailyBudget]
  func initializeDailyBudgets(
    startDate: Date,
    endDate: Date
  ) -> [DailyBudget] {
    let totalDays = startDate.daysUntil(endDate)
    let today = Date().formattedDate
    
    return (0...totalDays).compactMap { day -> DailyBudget? in
      guard let date = startDate.adding(
        by: .day, value: day
      ) else { return nil }
      
      return DailyBudget(
        date: date,
        harubee: date < today ? -1 : nil,
        memo: [],
        expense: date < today ? -1 : nil,
        income: nil
      )
    }
  }
  
  /// 이후에 빠져나갈 고정 지출 금액을 뺀 잔액을 구합니다
  /// - Parameters:
  ///   - current: 현재 잔액
  ///   - items: 고정 지출 내역
  ///   - anchor: 계산될 고정 지출 내역의 기준 날짜
  /// - Returns: 계산된 남은 잔액
  func calculateInitialBalance(
    current: Int,
    items: [TransactionItem]
  ) -> Int {
    let today = Date().formattedDate
    let totalFixedExpensesAfterToday = items
      .filter { $0.date > today }
      .reduce(0) { $0 + $1.price }
    
    return current - totalFixedExpensesAfterToday
  }
}

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
  ) throws {
    
    // 1. 고정 수입일 저장
    userDefaultsRepository.saveIncomeDay(fixedIncomeDay)
    
    // 2. 이번, 다음달 SalaryBudget 생성
    for i in (0...1) {
      // 수입일(day)과 기준 날짜를 가지고 새로운 시작, 종료 날짜를 계산
      // 첫번째 SalaryBudget의 endDate + 하루는 다음 기간 날짜에 포함되기 때문에
      // 다음 기간 SalaryBudget의 시작, 종료 날짜를 계산하기 위한 기준 날짜가 됨
      let anchorDate = endDate.formattedDate.adding(by: .day, value: i)!
      let (start, end) = Date.calculateStartAndEndDate(incomeDay: fixedIncomeDay, anchor: anchorDate)
      
      // SalaryBudget 생성 및 배열에 추가
      var salaryBudget = SalaryBudget.create(
        startDate: start,
        endDate: end,
        fixedIncome: fixedIncomeAmount,
        fixedExpenses: fixedExpenses
      )
      
      // 이번 기간의 SalaryBudget인 경우 지난 날짜의 DailyBudget 포멧 변환
      // (온보딩에서 입력한 잔액으로 변경 및 하루비, 지출 -1로 입력)
      if i == 0 {
        salaryBudget = convertToOnboardingFormat(
          from: salaryBudget,
          currentBalance: currentBalance
        )
      }
      
      // Repository에 저장하기
      salaryBudgetRepository.create(salaryBudget)
    }
  }
}

private extension SaveOnboardingDataUseCaseImpl {
  /// SalaryBudget을 온보딩 포멧에 맞춰 변환합니다.
  /// (과거 날짜에 대한 DailyBudget을 숨기기 위함)
  /// - Parameters:
  ///   - salaryBudget: SalaryBudget
  ///   - currentBalance: 현재 잔액
  /// - Returns: 온보딩 포멧으로 변환된 SalaryBudget
  func convertToOnboardingFormat(
    from salaryBudget: SalaryBudget,
    currentBalance: Int
  ) -> SalaryBudget {
    let today = Date().formattedDate
    let days = today.daysUntil(salaryBudget.endDate)
    var newDailyBudgets = salaryBudget.dailyBudgets
    
    // 현재 잔액에서 오늘 이후 빠져나갈 고정 지출 금액들을 차감
    let newBalance = currentBalance - salaryBudget.fixedExpenses
      .filter { $0.date > today }
      .reduce(0) { $0 + $1.price }
    
    // 오늘 날짜를 기준으로 기본 하루비 계산
    let newDefaultHarubee = Double(newBalance) / Double(days + 1)
    
    // 과거 날짜에 대한 DailyBudget 값 변경
    for i in 0..<newDailyBudgets.count {
      if newDailyBudgets[i].date >= today { break }
      
      newDailyBudgets[i].harubee = -1
      newDailyBudgets[i].expense = -1
    }
    
    return SalaryBudget(
      startDate: salaryBudget.startDate,
      endDate: salaryBudget.endDate,
      fixedIncome: salaryBudget.fixedIncome,
      fixedExpenses: salaryBudget.fixedExpenses,
      balance: newBalance,
      defaultHarubee: newDefaultHarubee,
      dailyBudgets: newDailyBudgets
    )
  }
}

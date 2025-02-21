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
    let salaryBudget = SalaryBudget.create(
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncomeAmount,
      fixedExpenses: fixedExpenses
    )
    
    // 4. 초기(첫번째) 데이터로 표현될 SalaryBudget으로 변환
    let initialSalaryBudget = convertToOnboardingFormat(
      from: salaryBudget,
      currentBalance: currentBalance
    )
    
    // 5. Repository에 저장하기
    salaryBudgetRepository.create(initialSalaryBudget)
    
    // TODO: 다음달 SalaryBudget 생성 시점 생각하기 (온보딩에서 바로 처리 or 홈화면에서 기존 createNextSalaryBudgetIfNeeded() 호출할지
    
    return salaryBudget
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

//
//  BalanceAdjustmentUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

final class BalanceAdjustmentUseCaseImpl: BalanceAdjustmentUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let dailyBudgetRepository: DailyBudgetRepository
  
  init(
    salaryBudgetRepository: SalaryBudgetRepository,
    dailyBudgetRepository: DailyBudgetRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.dailyBudgetRepository = dailyBudgetRepository
  }
  
  func updateBalance(
    salaryBudget: SalaryBudget,
    newBalance: Int
  ) throws -> SalaryBudget {
    // 1. 새로운 잔액으로 업데이트하기
    let newSalaryBudget = try salaryBudgetRepository.updateBalance(
      salaryBudget.id,
      balance: newBalance
    )
    
    // 2. 새로 업데이트된 SalaryBudget의 잔액으로 기본 하루비 다시 계산하기
    let newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: newSalaryBudget,
      anchorDate: .now
    )
    
    // 3. SalaryBudget에 기본 하루비 업데이트하기
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
  
  func recordTransaction(
    expense: Int?,
    income: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget) {
    // 1. 날짜 유효성 검사
    let date = date.formattedDate
    guard date >= salaryBudget.startDate
            && date <= salaryBudget.endDate else {
      throw DomainError.dateOutOfRange
    }
    
    // 2. SalaryBudget 내에서 dailyBudget의 index 찾기
    guard let index = salaryBudget.dailyBudgets.firstIndex(where: {
      $0.date == date.formattedDate
    }) else { throw DomainError.dataNotFound }
    
    // 3. 실제 지출 변경 전, 후, 차액 저장
    let previousExpense = salaryBudget.dailyBudgets[index].expense ?? 0
    let currentExpense = expense ?? 0
    let diffExpense = currentExpense - previousExpense
    
    // 4. 수입 변경 전, 후, 차액 저장
    let previousIncome = salaryBudget.dailyBudgets[index].income ?? 0
    let currentIncome = income ?? 0
    let diffIncome = currentIncome - previousIncome
    
    // 5. 지출, 수입 입력 시점에 DailyBudget의 하루비가 nil인 경우, 기본 하루비로 저장
    let harubee = salaryBudget.dailyBudgets[index].harubee ?? Int(salaryBudget.defaultHarubee)
      
    let newDailyBudget = try dailyBudgetRepository.updateDailyBudget(
      salaryBudget.dailyBudgets[index].id,
      harubee: .set(harubee),
      expence: .set(currentExpense),
      income: .set(currentIncome),
      memo: .keep
    )
    
    // 7. 잔액 업데이트
    let newBalance = salaryBudget.balance - diffExpense + diffIncome
    
    // 8. SalaryBudget 업데이트
    let newSalaryBudget = try self.updateBalance(
      salaryBudget: salaryBudget,
      newBalance: newBalance
    )
    
    return (newDailyBudget, newSalaryBudget)
  }
}

extension BalanceAdjustmentUseCaseImpl: DefaultHarubeeCalculatable {}

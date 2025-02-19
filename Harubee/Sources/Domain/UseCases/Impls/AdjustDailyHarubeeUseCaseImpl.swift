//
//  AdjustHarubeeUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

final class AdjustDailyHarubeeUseCaseImpl: AdjustDailyHarubeeUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let dailyBudgetRepository: DailyBudgetRepository
  
  init(
    salaryBudgetRepository: SalaryBudgetRepository,
    dailyBudgetRepository: DailyBudgetRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.dailyBudgetRepository = dailyBudgetRepository
  }
  
  func updateHarubee(
    amount: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget) {
    
    let date = date.formattedDate
    guard date >= salaryBudget.startDate
            && date <= salaryBudget.endDate else {
      throw DomainError.dateOutOfRange
    }
    
    var salaryBudget = salaryBudget
    
    // 1. DailyBudget 찾기
    guard let index = salaryBudget.dailyBudgets.firstIndex(where: {
      $0.date == date.formattedDate
    }) else { throw DomainError.dataNotFound }
    
    // 2. SalaryBudget에서 해당 날짜의 DailyBudget 하루비 업데이트
    salaryBudget.dailyBudgets[index].harubee = amount
    
    // 3. DailyBudget 업데이트
    let newDailyBudget = try dailyBudgetRepository.updateHarubee(
      salaryBudget.dailyBudgets[index].id,
      harubee: amount
    )
    
    // 4. SalaryBudget의 기본하루비 업데이트
    let newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: salaryBudget,
      anchorDate: .now
    )
    let newSalaryBudget = try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
    
    return (newDailyBudget, newSalaryBudget)
  }
}

extension AdjustDailyHarubeeUseCaseImpl: DefaultHarubeeCalculatable {}

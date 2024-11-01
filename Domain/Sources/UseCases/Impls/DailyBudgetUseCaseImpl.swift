//
//  DailyBudgetUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Core

public final class DailyBudgetUseCaseImpl: DailyBudgetUseCase {
  
  private let dailyBudgetRepository: DailyBudgetRepository
  private let salaryBudgetUseCase: SalaryBudgetUseCase
  
  public init(
    dailyBudgetRepository: DailyBudgetRepository,
    salaryBudgetUseCase: SalaryBudgetUseCase
  ) {
    self.dailyBudgetRepository = dailyBudgetRepository
    self.salaryBudgetUseCase = salaryBudgetUseCase
  }
  
  public func getDailyBudget(
    date: Date
  ) throws -> DailyBudget {
    // 1. 오늘에 해당하는 DailyBudget 찾기
    guard let budget = try dailyBudgetRepository.readByDate(date.formattedDate) else {
      throw DomainError.dataNotFound
    }
    
    // 2. DailyBudget 반환하기
    return budget
  }
  
  public func adjustHarubee(
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
    let newSalaryBudget = try salaryBudgetUseCase.updateDefaultHarubee(salaryBudget: salaryBudget)
    
    return (newDailyBudget, newSalaryBudget)
  }
  
  // TODO: 실제 지출, 수입 기록 시 기본 하루비도 같이 변경되어야 합니다. 추가적인 로직 필요
  public func recordTransaction(
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
    
    var salaryBudget = salaryBudget
    
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
    
    // 5. DailyBudget 업데이트 (실제 지출, 수입 기록)
    let newDailyBudget = try dailyBudgetRepository.updateTransaction(
      salaryBudget.dailyBudgets[index].id,
      expense: currentExpense,
      income: currentIncome
    )
    
    // 6. 잔액 업데이트
    let newBalance = salaryBudget.balance - diffExpense + diffIncome
    
    // 7. SalaryBudget 업데이트
    let newSalaryBudget = try salaryBudgetUseCase.updateBalance(
      salaryBudget: salaryBudget,
      newBalance: newBalance
    )
    
    return (newDailyBudget, newSalaryBudget)
  }
  
  public func updateMemoList(
    memoList: [String],
    dailyBudget: DailyBudget
  ) throws -> DailyBudget {
    
    return try dailyBudgetRepository.updateMemo(
      dailyBudget.id,
      memo: memoList
    )
  }
}

//
//  BudgetPeriodUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Core

public final class SalaryBudgetUseCaseImpl: SalaryBudgetUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let calculateUseCase: CalculateUseCase
  
  public init(
    salaryBudgetRepository: SalaryBudgetRepository,
    calculateUseCase: CalculateUseCase
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.calculateUseCase = calculateUseCase
  }
  
  public func createSalaryBudget(
    startDate: Date,
    endDate: Date,
    previousExpense: Int?,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget {
    
    // 1. date 포멧 변경
    let startDate = startDate.formattedDate
    let endDate = endDate.formattedDate
    
    // 2. 총 고정 지출 금액 계산하기
    let totalFixedExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    
    // 3. 고정 수입에서 고정 지출을 뺀 금액 잔액으로 설정하기
    var initialBalance = fixedIncome - totalFixedExpenses
    
    // 3-1. 만약 온보딩에서 이전 지출 금액을 받은 경우 잔액 다시 계산하기
    if let previousExpense {
      initialBalance -= previousExpense
    }
    
    // 4. 예산 기간의 일자 개수 구하기
    let calendar = Calendar.current
    let days = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    
    // 5. 잔액을 예산 기간의 일자 개수로 나누어 기본 하루비 설정하기
    let defaultHarubee = Double(initialBalance) / Double(days)
    
    // 6. 각 날짜별로 DailyBudget 생성하기
    let dailyBudgets = (0...days).compactMap { day -> DailyBudget? in
      guard let date = calendar.date(
        byAdding: .day,
        value: day,
        to: startDate
      ) else { return nil }
      
      return DailyBudget(
        id: UUID().uuidString,
        date: date,
        harubee: nil,
        memo: [],
        expense: nil,
        income: nil
      )
    }
    
    // 7. SalaryBudget 생성하기
    let salaryBudget = SalaryBudget(
      id: UUID().uuidString,
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncome,
      fixedExpenses: fixedExpenses,
      balance: initialBalance,
      defaultHarubee: defaultHarubee,
      dailyBudgets: dailyBudgets
    )
    
    // 8. 중복되는 SalaryBudget이 있는지 찾기
    let salaryBudgets = try salaryBudgetRepository.readAll()
    if salaryBudgets.contains(
      where: { $0.startDate == salaryBudget.startDate }
    ) {
      throw DomainError.duplicateData
    }
    
    // 9. Repository에 저장하기
    salaryBudgetRepository.create(salaryBudget)
    
    return salaryBudget
  }
  
  public func getAllSalaryBudget() throws -> [SalaryBudget] {
    return try salaryBudgetRepository.readAll()
  }
  
  public func getSalaryBudget(
    date: Date?
  ) throws -> SalaryBudget {
    // 1. date 포멧 변경
    let targetDate = (date ?? Date()).formattedDate
    
    // 2. 특정 날짜에 해당하는 SalaryBudget 가져오기
    guard let salaryBudget = try salaryBudgetRepository.readByStartDate(targetDate) else {
      throw DomainError.dataNotFound
    }
    
    return salaryBudget
  }
  
  public func updateBalance(
    salaryBudget: SalaryBudget,
    newBalance: Int
  ) throws -> SalaryBudget {
    // 1. 새로운 잔액으로 업데이트하기
    let newSalaryBudget = try salaryBudgetRepository.updateBalance(
      salaryBudget.id,
      balance: newBalance
    )
    
    // 2. 새로 업데이트된 SalaryBudget의 잔액으로 기본 하루비 다시 계산하기
    let newDefaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      salaryBudget: newSalaryBudget
    )
    
    // 3. SalaryBudget에 기본 하루비 업데이트하기
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
  
  public func updateDefaultHarubee(
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    let newDefaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      salaryBudget: salaryBudget
    )
    
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
}

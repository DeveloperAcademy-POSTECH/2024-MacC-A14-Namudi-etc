//
//  BudgetPeriodUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

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
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget {
    // 초기 하루비 계산
    let totalFixedExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    let initialBalance = fixedIncome - totalFixedExpenses
    
    let calendar = Calendar.current
    let days = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    
    let defaultHarubee = Double(initialBalance / days)
    
    // 각 날짜별 DailyBudget 생성
    let dailyBudgets = (0...days).compactMap { day -> DailyBudget? in
      guard let date = calendar.date(byAdding: .day, value: day, to: startDate) else { return nil }
      
      return DailyBudget(
        id: UUID().uuidString,
        date: date,
        harubee: nil,
        memo: [],
        expense: nil,
        income: nil
      )
    }
    
    // SalaryBudget 생성
    let salaryBudget = SalaryBudget(
      id: UUID().uuidString,
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncome,
      fixedExpenses: fixedExpenses,
      balance: initialBalance,
      defaultHarubee: Double(defaultHarubee),
      dailyBudgets: dailyBudgets
    )
    
    let salaryBudgets = try salaryBudgetRepository.readAll()
    if salaryBudgets.contains(
      where: { $0.startDate == salaryBudget.startDate }
    ) {
      throw DomainError.duplicateData
    }
    
    // Repository에 저장
    salaryBudgetRepository.create(salaryBudget)
    
    return salaryBudget
  }
  
  public func getSalaryBudget(
    date: Date?
  ) throws -> SalaryBudget {
    let targetDate = date ?? Date()
    
    // 모든 SalaryBudget을 가져와서 해당 날짜가 포함된 것을 찾음
    let salaryBudgets = try salaryBudgetRepository.readAll()
    
    // first(where:)를 사용하여 조건에 맞는 예산을 찾음
    guard let salaryBudget = salaryBudgets.first(
      where: { budget in
        let budgetRange = budget.startDate...budget.endDate
        return budgetRange.contains(targetDate)
      }) else {
      throw DomainError.dataNotFound
    }
    
    return salaryBudget
  }
  
  public func updateBalance(
    salaryBudget: SalaryBudget, newBalance: Int
  ) throws {
    // 기존 SalaryBudget이 존재하는지 확인
    guard let _ = try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) else {
      throw DomainError.dataNotFound
    }
    
    // 잔액 업데이트
    try salaryBudgetRepository.updateBalance(salaryBudget.id, balance: newBalance)
    
    // 기본 하루비 재계산
    let newDefaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      balance: newBalance,
      startDate: Date(),
      endDate: salaryBudget.endDate,
      salaryBudget: salaryBudget
    )
    
    // 기본 하루비 업데이트
    try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: Double(newDefaultHarubee)
    )
  }
}

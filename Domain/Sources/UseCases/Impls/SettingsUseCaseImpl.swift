//
//  SettingsUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class SettingsUseCaseImpl: SettingsUseCase {
  
  private let userDefaultsRepository: UserDefaultsRepository
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let salaryBudgetUseCase: SalaryBudgetUseCase
  private let calculateUseCase: CalculateUseCase
  
  public init(
    userDefaultsRepository: UserDefaultsRepository,
    salaryBudgetRepository: SalaryBudgetRepository,
    salaryBudgetUseCase: SalaryBudgetUseCase,
    calculateUseCase: CalculateUseCase
  ) {
    self.userDefaultsRepository = userDefaultsRepository
    self.salaryBudgetRepository = salaryBudgetRepository
    self.salaryBudgetUseCase = salaryBudgetUseCase
    self.calculateUseCase = calculateUseCase
  }
  
  public func setIncomeDay(
    day: Int
  ) throws {
    guard (1...31).contains(day) else {
      throw DomainError.dateOutOfRange
    }
    try userDefaultsRepository.saveIncomeDay(day)
  }
  
  public func getIncomeDay(
  ) throws -> Int {
    guard let incomeDay = userDefaultsRepository.readIncomeDay() else {
      // 없는 경우 기본값으로 1일 설정
      try userDefaultsRepository.saveIncomeDay(1)
      return 1
    }
    return incomeDay
  }
  
  public func setFixedIncome(
    amount: Int
  ) throws {
    // 금액 유효성 검사
    guard amount >= 10000 else {
      throw DomainError.invalidAmount
    }
    
    do {
      // 현재 진행 중인 예산이 있는 경우
      let currentSalaryBudget = try salaryBudgetUseCase.getSalaryBudget(date: nil)
      try salaryBudgetRepository.updateFixedIncome(
        currentSalaryBudget.id,
        fixedIncome: amount
      )
      
    } catch DomainError.dataNotFound {
      fatalError("월급일을 설정했으나 SalaryBudget이 없습니다.")
    }
  }
  
  public func getFixedIncome(
  ) throws -> Int {
    guard let currentSalaryBudget = try salaryBudgetRepository.readByStartDate(Date()) else {
      throw DomainError.dataNotFound
    }
    return currentSalaryBudget.fixedIncome
  }
  
  public func addFixedExpense(expense: TransactionItem) throws {
    let now = Date()
    
    // 1. 현재 SalaryBudget 조회
    guard let currentSalaryBudget = try salaryBudgetRepository.readByStartDate(now) else {
      throw DomainError.dataNotFound
    }
    
    // 2. 금액 검증
    guard expense.price >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 3. 중복 체크
    let isDuplicate = currentSalaryBudget.fixedExpenses.contains { item in
      item.name == expense.name &&
      Calendar.current.isDate(item.date, equalTo: expense.date, toGranularity: .day)
    }
    
    if isDuplicate {
      throw DomainError.duplicateData
    }
    
    // 4. 새로운 잔액 계산
    let newBalance = currentSalaryBudget.balance - expense.price
    
    // 5. 잔액이 음수가 되는지 체크
    guard newBalance >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 6. 고정 지출 목록 업데이트
    var updatedExpenses = currentSalaryBudget.fixedExpenses
    updatedExpenses.append(expense)
    
    // 7. 기본 하루비 재계산
    let defaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      balance: newBalance,
      startDate: now,
      endDate: currentSalaryBudget.endDate,
      salaryBudget: currentSalaryBudget
    )
    
    // 8. Repository 통해 저장
    try salaryBudgetRepository.updateSalaryBudget(
      currentSalaryBudget.id,
      fixedIncome: .keep,
      fixedExpenses: .set(updatedExpenses),
      balance: .set(newBalance),
      defaultHarubee: .set(defaultHarubee)
    )
  }
  
  public func updateFixedExpense(expense: TransactionItem) throws {
    let now = Date()
    
    // 1. 현재 SalaryBudget 조회
    guard let currentSalaryBudget = try salaryBudgetRepository.readByStartDate(now) else {
      throw DomainError.dataNotFound
    }
    
    // 2. 금액 검증
    guard expense.price >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 3. 기존 항목 찾기
    guard let index = currentSalaryBudget.fixedExpenses.firstIndex(where: { $0.id == expense.id }) else {
      throw DomainError.dataNotFound
    }
    
    // 4. 다른 항목과 중복 체크
    let isDuplicate = currentSalaryBudget.fixedExpenses
      .filter { $0.id != expense.id }
      .contains { item in
        item.name == expense.name &&
        Calendar.current.isDate(item.date, equalTo: expense.date, toGranularity: .day)
      }
    
    if isDuplicate {
      throw DomainError.duplicateData
    }
    
    // 5. 잔액 차이 계산
    let oldExpense = currentSalaryBudget.fixedExpenses[index].price
    let expenseDifference = expense.price - oldExpense
    let newBalance = currentSalaryBudget.balance - expenseDifference
    
    // 6. 잔액이 음수가 되는지 체크
    guard newBalance >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 7. 고정 지출 목록 업데이트
    var updatedExpenses = currentSalaryBudget.fixedExpenses
    updatedExpenses[index] = expense
    
    // 8. 기본 하루비 재계산
    let defaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      balance: newBalance,
      startDate: now,
      endDate: currentSalaryBudget.endDate,
      salaryBudget: currentSalaryBudget
    )
    
    // 9. Repository 통해 저장
    try salaryBudgetRepository.updateSalaryBudget(
      currentSalaryBudget.id,
      fixedIncome: .keep,
      fixedExpenses: .set(updatedExpenses),
      balance: .set(newBalance),
      defaultHarubee: .set(defaultHarubee)
    )
  }
  
  public func deleteFixedExpense(
    expense: TransactionItem
  ) throws {
    guard let currentSalaryBudget = try salaryBudgetRepository.readByStartDate(Date()) else {
      throw DomainError.dataNotFound
    }
    
    let updatedExpenses = currentSalaryBudget.fixedExpenses.filter { $0.id != expense.id }
    
    // 삭제할 항목이 없는 경우
    if updatedExpenses.count == currentSalaryBudget.fixedExpenses.count {
      throw DomainError.dataNotFound
    }
    
    try salaryBudgetRepository.updateFixedExpenses(currentSalaryBudget.id, fixedExpenses: updatedExpenses)
  }
  
  public func getFixedExpenses(
  ) throws -> [TransactionItem] {
    guard let currentSalaryBudget = try salaryBudgetRepository.readByStartDate(Date()) else {
      throw DomainError.dataNotFound
    }
    return currentSalaryBudget.fixedExpenses
  }
}

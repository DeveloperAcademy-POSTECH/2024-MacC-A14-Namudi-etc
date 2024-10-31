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
    // 1. 월급일이 1일부터 31일 사이에 속하는지 확인하기
    guard (1...31).contains(day) else {
      throw DomainError.dateOutOfRange
    }
    
    // 2. UserDefaults에 설정하기
    try userDefaultsRepository.saveIncomeDay(day)
  }
  
  public func getIncomeDay(
  ) throws -> Int {
    
    // 1. 월급일을 가져오고 저장된 월급일이 없으면 기본값 1로 설정하기
    guard let incomeDay = userDefaultsRepository.readIncomeDay() else {
      try userDefaultsRepository.saveIncomeDay(1)
      return 1
    }
    
    return incomeDay
  }
  
  public func setFixedIncome(
    amount: Int
  ) throws {
    // 1. 고정 수입이 10000원 이상인지 확인하기 (TODO: 금액 괜찮은지 확인 필요)
    guard amount >= 10000 else {
      throw DomainError.invalidAmount
    }
    
    do {
      // 1. 오늘을 포함하고 있는 SalaryBudget이 있는지 확인하기
      let currentSalaryBudget = try salaryBudgetUseCase.getSalaryBudget(date: nil)
      
      // 2-1. 있다면 고정 수입 업데이트하기
      try salaryBudgetRepository.updateFixedIncome(
        currentSalaryBudget.id,
        fixedIncome: amount
      )
      
    } catch DomainError.dataNotFound {
      // 2-2. 없다면 걍 강제종료 시켜버려 어차피 이 메소드는 설정-고정수입관리하기에서 할텐데 없을리가 있나
      fatalError("월급일을 설정했으나 SalaryBudget이 없습니다.")
    }
    
  }
  
  public func getFixedIncome(
  ) throws -> Int {
    // 1. 오늘을 포함하는 SalayBudget 가져오기
    let currentSalaryBudget = try salaryBudgetUseCase.getSalaryBudget(date: nil)
    
    return currentSalaryBudget.fixedIncome
  }
  
  public func addFixedExpense(expense: TransactionItem) throws {
    // Date() 값의 일관성을 위해 변수에 저장하기
    let now = Date()
    
    // 1. 오늘을 포함하는 SalayBudget 가져오기
    let currentSalaryBudget = try salaryBudgetUseCase.getSalaryBudget(date: now)
    
    // 2. 고정 지출 금액이 0원 이상인지 확인하기
    guard expense.price > 0 else {
      throw DomainError.invalidAmount
    }
    
    // 3. 중복된 고정 지출인지 확인하기 (금액이 다르면 별개의 고정 지출로 판단)
    let isDuplicate = currentSalaryBudget.fixedExpenses.contains { item in
      item.name == expense.name &&
      Calendar.current.isDate(item.date, equalTo: expense.date, toGranularity: .day)
    }
    
    // 4. 중복된다면 에러 발생시키기
    if isDuplicate {
      throw DomainError.duplicateData
    }
    
    // 5. 기존 잔액에서 추가된 고정 지출 금액을 빼서 새로운 잔액 계산하기
    let newBalance = currentSalaryBudget.balance - expense.price
    
    // 6. 잔액이 음수가 되는지 체크하기
    guard newBalance >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 7. SalaryBudget의 고정 지출 목록 업데이트하기
    var updatedExpenses = currentSalaryBudget.fixedExpenses
    updatedExpenses.append(expense)
    
    // 8. 기본 하루비 다시 계산하기
    let defaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      salaryBudget: currentSalaryBudget
    )
    
    // 9. Repository 통해 저장하기
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
    
    // 1. 오늘을 포함하는 SalayBudget 가져오기
    let currentSalaryBudget = try salaryBudgetUseCase.getSalaryBudget(date: now)
    
    // 2. 수정하는 고정 지출 금액이 0원 이상인지 확인하기
    guard expense.price >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 3. 기존 고정 지출 항목 찾기
    guard let index = currentSalaryBudget.fixedExpenses.firstIndex(where: { $0.id == expense.id }) else {
      throw DomainError.dataNotFound
    }
    
    // 4. 이전에 설정했던 고정 지출 금액과 새롭게 설정한 고정 지출 금액의 차이 계산하기
    let oldExpense = currentSalaryBudget.fixedExpenses[index].price
    let expenseDifference = expense.price - oldExpense
    
    // 5. 차이만큼 SalaryBudget의 잔액 업데이트하기
    let newBalance = currentSalaryBudget.balance - expenseDifference
    
    // 6. 잔액이 음수가 되는지 체크하기
    guard newBalance >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 7. 고정 지출 목록 업데이트하기
    var updatedExpenses = currentSalaryBudget.fixedExpenses
    updatedExpenses[index] = expense
    
    // 8. 기본 하루비 다시 계산하기
    let defaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      salaryBudget: currentSalaryBudget
    )
    
    // 9. Repository 통해 저장하기
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
    // 1. 삭제하려는 지출 항목을 제외한 나머지 지출 항목들만 선택하기
    let updatedExpenses = currentSalaryBudget.fixedExpenses.filter { $0.id != expense.id }
    
    // 2. 삭제할 항목이 존재하는지 확인하기
    if updatedExpenses.count == currentSalaryBudget.fixedExpenses.count {
      throw DomainError.dataNotFound
    }
    
    // 3. Repository 통해 저장하기
    try salaryBudgetRepository.updateFixedExpenses(currentSalaryBudget.id, fixedExpenses: updatedExpenses)
  }
  
  public func getFixedExpenses(
  ) throws -> [TransactionItem] {
    // 1. 오늘을 포함하는 SalayBudget 가져오기
    let currentSalaryBudget = try salaryBudgetUseCase.getSalaryBudget(date: nil)
    
    // 2. 고정 지출 목록 반환하기
    return currentSalaryBudget.fixedExpenses
  }
}

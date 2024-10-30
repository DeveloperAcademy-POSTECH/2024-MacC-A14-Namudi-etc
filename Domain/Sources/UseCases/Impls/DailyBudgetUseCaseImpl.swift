//
//  DailyBudgetUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class DailyBudgetUseCaseImpl: DailyBudgetUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let dailyBudgetRepository: DailyBudgetRepository
  private let calculateUseCase: CalculateUseCase
  
  public init(
    salaryBudgetRepository: SalaryBudgetRepository,
    dailyBudgetRepository: DailyBudgetRepository,
    calculateUseCase: CalculateUseCase
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.dailyBudgetRepository = dailyBudgetRepository
    self.calculateUseCase = calculateUseCase
  }
  
  public func getDailyBudget(
    date: Date
  ) throws -> DailyBudget {
    // 1. 오늘에 해당하는 DailyBudget 찾기
    guard let budget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // 2. DailyBudget 반환하기
    return budget
  }
  
  public func adjustHarubee(
    amount: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    // 1. DailyBudget 찾기
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // 2. DailyBudget 업데이트
    try dailyBudgetRepository.updateHarubee(dailyBudget.id, harubee: amount)
    
    // 3. 새로운 defaultHarubee 계산
    let newDefaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      balance: salaryBudget.balance,
      startDate: date,
      endDate: salaryBudget.endDate,
      salaryBudget: salaryBudget
    )
    
    // 4. SalaryBudget 업데이트
    try salaryBudgetRepository.updateDefaultHarubee(salaryBudget.id, defaultHarubee: Double(newDefaultHarubee))
    
    return try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) ?? salaryBudget
  }
  
  public func resetHarubee(
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    guard date >= salaryBudget.startDate && date <= salaryBudget.endDate else {
      throw DomainError.dateOutOfRange
    }
    
    // 1. DailyBudget 찾기
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // 2. DailyBudget 업데이트 (하루비를 nil로 설정)
    try dailyBudgetRepository.updateDailyBudget(
      dailyBudget.id,
      harubee: .set(nil),
      expence: .keep,
      income: .keep,
      memo: .keep
    )
    
    // 3. 새로운 defaultHarubee 계산
    let newDefaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      balance: salaryBudget.balance,
      startDate: date,
      endDate: salaryBudget.endDate,
      salaryBudget: salaryBudget
    )
    
    // 4. SalaryBudget 업데이트
    try salaryBudgetRepository.updateDefaultHarubee(salaryBudget.id, defaultHarubee: Double(newDefaultHarubee))
    
    return try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) ?? salaryBudget
  }
  
  public func recordExpense(
    expense: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    // 1. DailyBudget 찾기
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // 2. 이전 실제 지출 저장
    let previousExpense = dailyBudget.expense ?? 0
    
    // 3. DailyBudget 업데이트 (실제 지출 기록)
    try dailyBudgetRepository.updateExpense(dailyBudget.id, expense: expense)
    
    // 3. 잔액 업데이트
    let balanceDifference = previousExpense - expense
    let newBalance = salaryBudget.balance + balanceDifference
    
    // 4. SalaryBudget 업데이트
    try salaryBudgetRepository.updateBalance(salaryBudget.id, balance: newBalance)
    
    return try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) ?? salaryBudget
  }
  
  public func recordIncome(
    income: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    // 1. DailyBudget 찾기
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // 2. 이전 실제 수입 저장
    let previousIncome = dailyBudget.income ?? 0
    
    // 3. DailyBudget 업데이트 (실제 수입 기록)
    try dailyBudgetRepository.updateIncome(dailyBudget.id, income: income)
    
    // 4. 잔액 업데이트
    let balanceDifference = income - previousIncome
    let newBalance = salaryBudget.balance + balanceDifference
    
    // 4. SalaryBudget 업데이트
    try salaryBudgetRepository.updateBalance(salaryBudget.id, balance: newBalance)
    
    return try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) ?? salaryBudget
  }
  
  public func addMemo(
    memo: String,
    date: Date
  ) throws -> DailyBudget {
    // 1. DailyBudget 가져오기
    let dailyBudget = try getDailyBudget(date: date)
    
    // 2. 중복된 메모 있는지 찾기
    guard !dailyBudget.memo.contains(memo) else {
      throw DomainError.duplicateData
    }
    
    // 3. 새로운 메모 저장하기
    var updatedMemos = dailyBudget.memo
    updatedMemos.append(memo)
    
    // 4.DailyBudget 업데이트
    try dailyBudgetRepository.updateMemo(dailyBudget.id, memo: updatedMemos)
    
    return try getDailyBudget(date: date)
  }
  
  public func updateMemo(
    oldMemo: String,
    newMemo: String,
    date: Date
  ) throws -> DailyBudget {
    // 1. DailyBudget 가져오기
    let dailyBudget = try getDailyBudget(date: date)
    
    // 2. 수정할 메모 찾기
    guard let index = dailyBudget.memo.firstIndex(of: oldMemo) else {
      throw DomainError.dataNotFound
    }
    
    // 3. 중복된 메모 있는지 찾기
    guard !dailyBudget.memo.contains(newMemo) else {
      throw DomainError.duplicateData
    }
    
    // 4. 메모 업데이트
    var updatedMemos = dailyBudget.memo
    updatedMemos[index] = newMemo
    
    // 5. DailyBudget 업데이트
    try dailyBudgetRepository.updateMemo(dailyBudget.id, memo: updatedMemos)
    
    return try getDailyBudget(date: date)
  }
  
  public func deleteMemo(
    memo: String,
    date: Date
  ) throws -> DailyBudget {
    // 1. DailyBudget 가져오기
    let dailyBudget = try getDailyBudget(date: date)
    
    // 2. 삭제할 메모 체크하기
    guard dailyBudget.memo.contains(memo) else {
      throw DomainError.dataNotFound
    }
    
    // 3. 삭제하려는 메모를 제외한 나머지 메모만 저장하기
    let updatedMemos = dailyBudget.memo.filter { $0 != memo }
    
    // 4. DailyBudget 업데이트
    try dailyBudgetRepository.updateMemo(dailyBudget.id, memo: updatedMemos)
    
    return try getDailyBudget(date: date)
  }
}

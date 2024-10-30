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
    guard let budget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    return budget
  }
  
  public func adjustHarubee(
    amount: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    // 해당 날짜의 DailyBudget 검색
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // 새로운 defaultHarubee 계산
    let newDefaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      balance: salaryBudget.balance,
      startDate: date,
      endDate: salaryBudget.endDate,
      salaryBudget: salaryBudget
    )
    
    // DailyBudget 업데이트
    try dailyBudgetRepository.updateHarubee(dailyBudget.id, harubee: amount)
    
    // SalaryBudget 업데이트
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
    
    // 해당 날짜의 DailyBudget 검색
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // DailyBudget 업데이트 (하루비를 nil로 설정)
    try dailyBudgetRepository.updateDailyBudget(
      dailyBudget.id,
      harubee: .set(nil),
      expence: .keep,
      income: .keep,
      memo: .keep
    )
    
    // 새로운 defaultHarubee 계산
    let newDefaultHarubee = try calculateUseCase.calculateDefaultHarubee(
      balance: salaryBudget.balance,
      startDate: date,
      endDate: salaryBudget.endDate,
      salaryBudget: salaryBudget
    )
    
    // SalaryBudget 업데이트
    try salaryBudgetRepository.updateDefaultHarubee(salaryBudget.id, defaultHarubee: Double(newDefaultHarubee))
    
    return try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) ?? salaryBudget
  }
  
  public func recordExpense(
    expense: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    // 해당 날짜의 DailyBudget 검색
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // DailyBudget 업데이트
    try dailyBudgetRepository.updateExpense(dailyBudget.id, expense: expense)
    
    // 잔액 업데이트
    let previousExpense = dailyBudget.expense ?? 0
    let balanceDifference = previousExpense - expense
    let newBalance = salaryBudget.balance + balanceDifference
    
    try salaryBudgetRepository.updateBalance(salaryBudget.id, balance: newBalance)
    
    return try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) ?? salaryBudget
  }
  
  public func recordIncome(
    income: Int,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    // 해당 날짜의 DailyBudget 검색
    guard let dailyBudget = try dailyBudgetRepository.readByDate(date) else {
      throw DomainError.dataNotFound
    }
    
    // DailyBudget 업데이트
    try dailyBudgetRepository.updateIncome(dailyBudget.id, income: income)
    
    // 잔액 업데이트
    let previousIncome = dailyBudget.income ?? 0
    let balanceDifference = income - previousIncome
    let newBalance = salaryBudget.balance + balanceDifference
    
    try salaryBudgetRepository.updateBalance(salaryBudget.id, balance: newBalance)
    
    return try salaryBudgetRepository.readByStartDate(salaryBudget.startDate) ?? salaryBudget
  }
  
  public func addMemo(
    memo: String,
    date: Date
  ) throws -> DailyBudget {
    let dailyBudget = try getDailyBudget(date: date)
    
    guard !dailyBudget.memo.contains(memo) else {
      throw DomainError.duplicateData
    }
    
    var updatedMemos = dailyBudget.memo
    updatedMemos.append(memo)
    
    try dailyBudgetRepository.updateMemo(dailyBudget.id, memo: updatedMemos)
    
    return try getDailyBudget(date: date)
  }
  
  public func updateMemo(
    oldMemo: String,
    newMemo: String,
    date: Date
  ) throws -> DailyBudget {
    let dailyBudget = try getDailyBudget(date: date)
    
    guard let index = dailyBudget.memo.firstIndex(of: oldMemo) else {
      throw DomainError.dataNotFound
    }
    
    guard !dailyBudget.memo.contains(newMemo) else {
      throw DomainError.duplicateData
    }
    
    var updatedMemos = dailyBudget.memo
    updatedMemos[index] = newMemo
    
    try dailyBudgetRepository.updateMemo(dailyBudget.id, memo: updatedMemos)
    
    return try getDailyBudget(date: date)
  }
  
  public func deleteMemo(
    memo: String,
    date: Date
  ) throws -> DailyBudget {
    let dailyBudget = try getDailyBudget(date: date)
    
    guard dailyBudget.memo.contains(memo) else {
      throw DomainError.dataNotFound
    }
    
    let updatedMemos = dailyBudget.memo.filter { $0 != memo }
    
    try dailyBudgetRepository.updateMemo(dailyBudget.id, memo: updatedMemos)
    
    return try getDailyBudget(date: date)
  }
}

//
//  CalculateUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class CalculateUseCaseImpl: CalculateUseCase {
  
  private let calendar: Calendar
  
  public init(calendar: Calendar = .current) {
    self.calendar = calendar
  }
  
  public func calculateDefaultHarubee(
    balance: Int,
    startDate: Date,
    endDate: Date,
    salaryBudget: SalaryBudget
  ) throws -> Double {
    // 1. endDate가 startDate 이후인지 확인하기
    guard startDate <= endDate else {
      throw DomainError.invalidDateRange
    }
    
    // 2. startDate부터 endDate까지의 일자 개수 계산하기 (오늘 포함하기)
    let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    let totalDays = numberOfDays + 1
    
    // 3. 시작일 이후(미래)의 DailyBudgets 필터링하기
    let futureDailyBudgets = salaryBudget.dailyBudgets.filter {
      $0.date > startDate &&
      $0.date <= endDate
    }
    
    // 4. 조정된 하루비의 총액 계산하기
    let adjustedFutureTotal = futureDailyBudgets
      .compactMap { $0.harubee }  // nil이 아닌 것(조정된 것)만
      .reduce(0, +)
    
    // 4. 조정되지 않은 일자 개수 계산하기
    let unadjustedFutureDays = futureDailyBudgets
      .filter { $0.harubee == nil }
      .count
    
    // 5. 모든 미래 날짜가 조정된 경우 기본 하루비 0으로 설정하기
    guard unadjustedFutureDays > 0 else {
      return 0.0
    }
    
    // 6. 잔액에서 미래의 조정된 하루비 총액을 제외하고 남은 금액을 총 미래 날수로 나누기
    return Double(balance - adjustedFutureTotal) / Double(totalDays)
  }
  
  public func calculateAverageHarubee(
    salaryBudget: SalaryBudget,
    startDate: Date?
  ) throws -> Double {
    // 1. startDate가 nil이면 오늘로 설정하기
    let startDate = startDate ?? Date()
    
    // 2. startDate가 예산 기간 내에 있는지 확인하기
    guard startDate >= salaryBudget.startDate && startDate <= salaryBudget.endDate else {
      throw DomainError.dateOutOfRange
    }
    
    // 3. 남은 기간 계산하기 (오늘도 포함)
    let remainingDays = calendar.dateComponents(
      [.day],
      from: startDate,
      to: salaryBudget.endDate
    ).day ?? 0
    let daysLeft = remainingDays + 1
    
    // 4. 마지막 날인 경우(남은 기간이 0) 남은 잔액 반환하기
    guard daysLeft > 0 else {
      return Double(salaryBudget.balance)
    }
    
    // 5. 잔액을 남은 기간으로 나누어 평균 계산하기
    return Double(salaryBudget.balance) / Double(daysLeft)
  }
}

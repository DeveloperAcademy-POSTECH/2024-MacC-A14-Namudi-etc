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
    guard startDate <= endDate else {
      throw DomainError.invalidDateRange
    }
    
    // 1. 미래 기간 계산
    let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    let totalDays = numberOfDays + 1
    
    // 2. 미래의 조정된 하루비가 있는 날들만 필터링
    let futureDailyBudgets = salaryBudget.dailyBudgets.filter {
      $0.date > startDate &&  // 시작일 이후만
      $0.date <= endDate      // 종료일까지
    }
    
    // 3. 미래의 조정된 하루비 총액 계산
    let adjustedFutureTotal = futureDailyBudgets
      .compactMap { $0.harubee }  // nil이 아닌 것(조정된 것)만
      .reduce(0, +)
    
    // 4. 미래의 조정되지 않은 날수 계산
    let unadjustedFutureDays = futureDailyBudgets
      .filter { $0.harubee == nil }
      .count
    
    // 5. 모든 미래 날짜가 조정된 경우
    guard unadjustedFutureDays > 0 else {
      return 0.0  // 모든 날이 이미 조정되었으므로 기본 하루비는 0
    }
    
    // 6. 잔액에서 미래의 조정된 하루비 총액을 제외하고
    // 남은 금액을 총 미래 날수로 나눔
    return Double(balance - adjustedFutureTotal) / Double(totalDays)
  }
  
  public func calculateAverageHarubee(
    salaryBudget: SalaryBudget,
    fromDate: Date?
  ) throws -> Double {
    let startDate = fromDate ?? Date()
    
    // 시작일이 예산 기간 내에 있는지 확인
    guard startDate >= salaryBudget.startDate && startDate <= salaryBudget.endDate else {
      throw DomainError.dateOutOfRange
    }
    
    // 남은 기간 계산
    let remainingDays = calendar.dateComponents(
      [.day],
      from: startDate,
      to: salaryBudget.endDate
    ).day ?? 0
    
    // 오늘도 포함
    let daysLeft = remainingDays + 1
    
    guard daysLeft > 0 else {
      // 마지막 날인 경우 남은 잔액 반환
      return Double(salaryBudget.balance)
    }
    
    // 남은 잔액을 남은 일수로 나누어 평균 계산
    return Double(salaryBudget.balance) / Double(daysLeft)
  }
}

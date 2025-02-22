//
//  SalaryBudgetManangementUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

final class SalaryBudgetUseCaseImpl: SalaryBudgetUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let dailyBudgetRepository: DailyBudgetRepository
  private let userDefaultsRepository: UserDefaultsRepository
  
  init(
    salaryBudgetRepository: SalaryBudgetRepository,
    dailyBudgetRepository: DailyBudgetRepository,
    userDefaultsRepository: UserDefaultsRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.dailyBudgetRepository = dailyBudgetRepository
    self.userDefaultsRepository = userDefaultsRepository
  }
  
  func fetchAll() throws -> [SalaryBudget] {
    return try salaryBudgetRepository.readAll()
  }
  
  func fetchCurrent() throws -> SalaryBudget {
    let today = Date().formattedDate
    let salaryBudget = try salaryBudgetRepository.readByTargetDateContaining(today)
    
    // Case 1. 이번 기간 salaryBudget 존재
    if let salaryBudget = salaryBudget {
      // 다음달 salaryBudget 존재 여부 확인 후 필요하면 생성
      try createNextSalaryBudgetIfNeeded(salaryBudget: salaryBudget)
      
      // 과거 하루비가 입력되지 않은 날짜 하루비 업데이트
      return try updateHarubeeForPastDates(salaryBudget)
      
    // Case 2. 이번 기간 salaryBudget 없음
    // -> 가장 마지막에 생성된 SalaryBudget 기점부터 이후 SalaryBudget 모두 생성
    } else {
      // 가장 마지막의 SalaryBudget 가져오기
      let allSalaryBudgets = try salaryBudgetRepository.readAll()
      var lastSalaryBudget = allSalaryBudgets.last!
      
      let incomeDay = userDefaultsRepository.readIncomeDay()!
      
      // SalaryBudget이 없는 시점부터 이번 기간 다음의 SalaryBudget까지 생성
      while true {
        let anchorDate = lastSalaryBudget.endDate.adding(by: .day, value: 1)!
        let (start, end) = Date.calculateStartAndEndDate(
          incomeDay: incomeDay,
          anchor: anchorDate
        )
        
        var newSalaryBudget = SalaryBudget.create(
          startDate: start,
          endDate: end,
          fixedIncome: lastSalaryBudget.fixedIncome,
          fixedExpenses: lastSalaryBudget.fixedExpenses
        )
        
        // 새로 생성된 SalaryBudget의 각 DailyBudget 일별 하루비 설정
        newSalaryBudget = try updateHarubeeForPastDates(newSalaryBudget)
        
        // 저장
        salaryBudgetRepository.create(newSalaryBudget)
        
        // 저장된 새 SalaryBudget이 다음 기간의 SalaryBudget인 경우 종료
        if newSalaryBudget.startDate > today { break }
        
        // 마지막 salaryBudget 및 시작 날짜 업데이트
        lastSalaryBudget = newSalaryBudget
      }
      
      return lastSalaryBudget
    }
  }
  
  func fetch(date: Date) throws -> SalaryBudget {

    guard let salaryBudget = try salaryBudgetRepository.readByTargetDateContaining(
      date.formattedDate
    ) else {
      throw DomainError.dataNotFound
    }
    
    return salaryBudget
  }
  
  func deleteAll() throws {
    try salaryBudgetRepository.deleteAll()
  }
  
}

extension SalaryBudgetUseCaseImpl: DefaultHarubeeCalculatable {}

private extension SalaryBudgetUseCaseImpl {
  
  /// 다음 월급 달의 SalaryBudget을 생성합니다.
  /// - Parameter salaryBudget: 현재 SalaryBudget
  func createNextSalaryBudgetIfNeeded(
    salaryBudget: SalaryBudget
  ) throws {
    // 1. 현재 SalaryBudget 종료 날짜 + 1 (다음 기간의 포함되는 날짜가 됨)
    let date = salaryBudget.endDate.adding(by: .day, value: 1)!
    
    // 2. 다음 기간에 해당하는 SalaryBudget 가져옴
    let nextSalaryBudget = try salaryBudgetRepository.readByTargetDateContaining(date)
    
    // 3. 다음 기간에 해당하는 SalaryBudget이 존재할 시 리턴
    guard nextSalaryBudget == nil else { return }
    
    // 4. 다음 기간의 시작, 종료 날짜를 구함
    let incomeDay = userDefaultsRepository.readIncomeDay()!
    let (nextStart, nextEnd) = Date.calculateStartAndEndDate(
      incomeDay: incomeDay,
      anchor: date
    )
    
    // 5. 다음 기간 생성
    let newSalaryBudget = SalaryBudget.create(
      startDate: nextStart,
      endDate: nextEnd,
      fixedIncome: salaryBudget.fixedIncome,
      fixedExpenses: salaryBudget.fixedExpenses
    )
    
    salaryBudgetRepository.create(newSalaryBudget)
  }
  
  /// 오늘날짜 이전에 해당하는 DailyBudget에 하루비가 저장되지 않았는지 확인 후 값을 넣어줍니다.
  /// - Parameter salaryBudget: 이번 기간의 SalaryBudget
  /// - Returns: 변경된 SalaryBudget
  func updateHarubeeForPastDates(_ salaryBudget: SalaryBudget) throws -> SalaryBudget {
    var salaryBudget = salaryBudget
    
    let now = Date().formattedDate
    var index = 0
    var newDefaultHarubee = 0.0
    
    // 1. 오늘 이전 날짜의 DailyBudget을 순회
    while salaryBudget.dailyBudgets[index].date < now {
      let dailyBudget = salaryBudget.dailyBudgets[index]
      
      // 1-1. 하루비가 조정된 경우 건너뜀
      if dailyBudget.harubee != nil {
        index += 1
        continue
      }
      
      // 2-2. 현재 dailyBudget 날짜를 기준으로
      // salaryBudget의 기본 하루비 계산
      newDefaultHarubee = self.calculateDefaultHarubee(
        salaryBudget: salaryBudget,
        anchorDate: dailyBudget.date
      )
      
      // 2-3. dailyBudget의 하루비를 기본 하루비로 업데이트
      salaryBudget.dailyBudgets[index] = try dailyBudgetRepository.updateHarubee(
        dailyBudget.id,
        harubee: Int(newDefaultHarubee)
      )
      
      index += 1
    }
    
    // 2. 오늘 날짜를 기준으로 기본 하루비 계산
    newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: salaryBudget,
      anchorDate: .now
    )
    
    // 3. 기본 하루비 업데이트
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
}

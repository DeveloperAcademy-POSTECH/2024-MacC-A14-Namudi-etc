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
  
  func fetchCurrent(date: Date?) throws -> SalaryBudget {
    let targetDate = (date ?? Date()).formattedDate
    
    guard let salaryBudget = try salaryBudgetRepository.readByTargetDateContaining(
      targetDate
    ) else {
      throw DomainError.dataNotFound
    }
    
    // TODO: 구현 필요
    // 다음 기간에 해당하는 SalaryBudget이 있는지 확인 후 생성
    try? createNextSalaryBudgetIfNeeded(salaryBudget: salaryBudget)
    
    // 이전 날짜에 입력되지 않은 하루비가 있는지 확인 후 값 설정
    return try updateHarubeeForPastDates(salaryBudget)
  }
  
  func deleteAll() throws {
    try salaryBudgetRepository.deleteAll()
  }
  
}

extension SalaryBudgetUseCaseImpl: DefaultHarubeeCalculatable, FixedExpensesRegeneratable {}

private extension SalaryBudgetUseCaseImpl {
  
  /// 다음 월급 달의 SalaryBudget을 생성합니다.
  /// - Parameter salaryBudget: 현재 SalaryBudget
  /// - `DomainError.dataNotFound`: IncomeDay를 찾을 수 없는 경우
  func createNextSalaryBudgetIfNeeded(
    salaryBudget: SalaryBudget
  ) throws {
    
    // TODO: 구현 필요
  }
  
  /// 오늘날짜 이전에 해당하는 DailyBudget에 하루비가 저장되지 않았는지 확인 후 값을 넣어줍니다.
  /// - Parameter salaryBudget: 이번 기간의 SalaryBudget
  /// - Returns: 변경된 SalaryBudget
  func updateHarubeeForPastDates(_ salaryBudget: SalaryBudget) throws -> SalaryBudget {
    var salaryBudget = salaryBudget
    
    let now = Date().formattedDate
    var index = 0
    
    // 1. 최근 접속 날짜 불러오기
    let recentAccessDay = userDefaultsRepository.readLastAccessDate() ?? now
    
    // 2. 최근 접속 날짜 업데이트
    userDefaultsRepository.saveLastAccessDate(now)
    
    // 3. 최근 접속 날짜가 오늘 날짜와 일치한 경우, 기존 salaryBudget 리턴
    if recentAccessDay.isToday { return salaryBudget }
    
    var newDefaultHarubee = 0.0
    
    // 4. 오늘 이전의 DailyBudget을 순회
    while salaryBudget.dailyBudgets[index].date != now {
      let dailyBudget = salaryBudget.dailyBudgets[index]
      
      // 4-1. 하루비가 조정된 경우 건너뜀
      if dailyBudget.harubee != nil {
        index += 1
        continue
      }
      
      // 4-2. 현재 dailyBudget 날짜를 기준으로
      // salaryBudget의 기본 하루비 계산
      newDefaultHarubee = self.calculateDefaultHarubee(
        salaryBudget: salaryBudget,
        anchorDate: dailyBudget.date
      )
      
      // 4-3. dailyBudget의 하루비를 기본 하루비로 업데이트
      salaryBudget.dailyBudgets[index] = try dailyBudgetRepository.updateHarubee(
        dailyBudget.id,
        harubee: Int(newDefaultHarubee)
      )
      
      index += 1
    }
    
    // 5. 오늘 날짜를 기준으로 기본 하루비 계산
    newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: salaryBudget,
      anchorDate: .now
    )
    
    // 6. 기본 하루비 업데이트
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
}

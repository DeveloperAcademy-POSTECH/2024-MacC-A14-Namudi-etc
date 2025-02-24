//
//  FixedTransactionManagementUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

final class FixedTransactionUseCaseImpl: FixedTransactionUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let userDefaultsRepository: UserDefaultsRepository
  
  init(
    salaryBudgetRepository: SalaryBudgetRepository,
    userDefaultsRepository: UserDefaultsRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.userDefaultsRepository = userDefaultsRepository
  }
  
  func updateIncome(
    salaryBudget: SalaryBudget,
    newIncome: Int
  ) throws -> SalaryBudget {
    
    // 1. 고정지출의 총 합계 계산
    let totalFixedExpense = salaryBudget.fixedExpenses.reduce(0) {
      $0 + $1.price
    }
    
    // 2. 이번 기간을 포함한 이후의 모든 SalaryBudget 가져오기
    let anchor = salaryBudget.startDate.adding(by: .day, value: -1)!
    let salaryBudgetsFromCurrent = try salaryBudgetRepository.readAll(after: anchor)
    
    // 3. 모든 SalaryBudget들을 업데이트하고, 이번 기간에 해당하는 SalaryBudget을 리턴
    return try salaryBudgetsFromCurrent
      .map {
        // 이번 기간의 SalaryBudget인 경우
        // 새로운 잔액 = 기존 잔액 - (기존 월급 - 새로운 월급)
        // 그 외에 SalaryBudget인 경우
        // 새로운 잔액 = 고정 수입 - 고정 지출 총합
        let newBalance = $0.id == salaryBudget.id
        ? $0.balance - ($0.fixedIncome - newIncome)
        : newIncome - totalFixedExpense
        
        var newSalaryBudget = $0
        newSalaryBudget.fixedIncome = newIncome
        newSalaryBudget.balance = newBalance
        
        // 기본 하루비 재계산
        let newDefaultHarubee = self.calculateDefaultHarubee(
          salaryBudget: newSalaryBudget,
          anchorDate: .now
        )
        
        // 업데이트
        return try salaryBudgetRepository.updateSalaryBudget(
          $0.id,
          fixedIncome: .set(newIncome),
          fixedExpenses: .keep,
          balance: .set(newBalance),
          defaultHarubee: .set(newDefaultHarubee)
        )
      }
      .filter { $0.id == salaryBudget.id }
      .first!
  }
  
  func updateExpenses(
    salaryBudget: SalaryBudget,
    expenses: [TransactionItem]
  ) throws -> SalaryBudget {
    
    let today = Date().formattedDate
    
    // 1. 총 고정 지출의 합계
    let totalExpenses = expenses.reduce(0) { $0 + $1.price }
    
    // 2. 기존 오늘 날짜 이후의 고정 지출의 합계
    let oldTotalExpenseFromToday = salaryBudget.fixedExpenses
      .filter{ $0.date > today }
      .reduce(0) { $0 + $1.price }
    
    // 3. 변경된 오늘 날짜 이후의 고정 지출의 합계
    let newTotalExpenseFromToday = expenses
      .filter { $0.date > today }
      .reduce(0) { $0 + $1.price }
    
    // 4. 이번 기간을 포함한 이후의 모든 SalaryBudget 가져오기
    let anchor = salaryBudget.startDate.adding(by: .day, value: -1)!
    let salaryBudgetsFromCurrent = try salaryBudgetRepository.readAll(after: anchor)
    
    // 5. 모든 SalaryBudget들을 업데이트하고, 이번 기간에 해당하는 SalaryBudget을 리턴
    return try salaryBudgetsFromCurrent
      .map {
        // 이번 기간의 SalaryBudget인 경우
        // 새로운 잔액 = 기존 잔액 - (기존 오늘 이후 고정 지출 총합 - 변경된 오늘 이후 고정 지출 총합)
        // 그 외에 SalaryBudget인 경우
        // 새로운 잔액 = 고정 수입 - 변경된 고정 지출 총합
        let newBalance = $0.id == salaryBudget.id
        ? $0.balance - (newTotalExpenseFromToday - oldTotalExpenseFromToday)
        : $0.fixedIncome - totalExpenses
        
        // 파라미터로 전달받은 고정 지출 내역들의 날짜를 SalaryBudget의 시작, 종료 날짜 사이의 날짜에 맞춰 변환
        let newFixedExpenses = expenses.recalculateDateInRange(
          startDate: $0.startDate,
          endDate: $0.endDate
        )
        
        var newSalaryBudget = $0
        newSalaryBudget.balance = newBalance
        newSalaryBudget.fixedExpenses = newFixedExpenses
        
        // 기본 하루비 재계산
        let newDefaultHarubee = self.calculateDefaultHarubee(
          salaryBudget: newSalaryBudget,
          anchorDate: .now
        )
        
        // 업데이트
        return try salaryBudgetRepository.updateSalaryBudget(
          $0.id,
          fixedIncome: .keep,
          fixedExpenses: .set(newFixedExpenses),
          balance: .set(newBalance),
          defaultHarubee: .set(newDefaultHarubee)
        )
      }
      .filter { $0.id == salaryBudget.id }
      .first!
  }
  
  func updateIncomeDay(
    day: Int,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    
    // 1. 월급일이 1일부터 31일 사이에 속하는지 확인하기
    guard (1...31).contains(day) else {
      throw DomainError.dateOutOfRange
    }
    
    // 2. UserDefaults에 설정하기
    userDefaultsRepository.saveIncomeDay(day)
    
    // 3. 이번 기간을 포함한 이후의 모든 SalaryBudget 가져오고 삭제
    let anchor = salaryBudget.startDate.adding(by: .day, value: -1)!
    try salaryBudgetRepository
      .readAll(after: anchor)
      .forEach { try salaryBudgetRepository.deleteById($0.id) }
    
    // 4. 이번, 다음달 SalaryBudget 생성
    var anchorDate = Date().formattedDate
    var newSalaryBudget = salaryBudget
    
    for i in (0...1) {
      // 기준 날짜, 수입일을 기반으로 새로운 시작, 종료 날짜 생성
      let (start, end) = Date.calculateStartAndEndDate(
        incomeDay: day,
        anchor: anchorDate
      )
      
      // SalaryBudget 생성
      var salaryBudget = SalaryBudget.create(
        startDate: start,
        endDate: end,
        fixedIncome: salaryBudget.fixedIncome,
        fixedExpenses: salaryBudget.fixedExpenses
      )
      
      // Repository에 저장하기
      salaryBudgetRepository.create(salaryBudget)
      
      // 기준 날짜 수정
      anchorDate = end.adding(by: .day, value: 1)!
      
      // 이번 기간의 SalaryBudget을 리턴하기 위함
      if i == 0 { newSalaryBudget = salaryBudget }
    }
    
    return newSalaryBudget
  }
}

extension FixedTransactionUseCaseImpl: DefaultHarubeeCalculatable {}



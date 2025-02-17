//
//  FixedTransactionManagementUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

final class FixedTransactionManagementUseCaseImpl: FixedTransactionManagementUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let userDefaultsRepository: UserDefaultsRepository
  
  init(
    salaryBudgetRepository: SalaryBudgetRepository,
    userDefaultsRepository: UserDefaultsRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.userDefaultsRepository = userDefaultsRepository
  }
  
  func updateFixedIncome(
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
  
  func updateFixedExpenses(
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
        
        // 이번 기간의 SalaryBudget인 경우 파라미터로 전달된 고정 지출 사용
        // 그 외에 SalaryBudget인 경우 날짜 새로 계산
        let newFixedExpenses = $0.id == salaryBudget.id
        ? expenses
        : regenerateFixedExpenses(
          startDate: $0.startDate,
          endDate: $0.endDate,
          from: expenses
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
  
  // TODO: 용도 다시 생각해보기
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
    
    // TODO: 수입 날짜 변경 시 새로운 SalaryBudget 생성 로직은 SalaryBudget 관리 유스케이스에서 구현 필요
//    // 3. 이번 기간을 포함한 이후의 모든 SalaryBudget 가져오고 삭제
//    let anchor = salaryBudget.startDate.adding(by: .day, value: -1)!
//    try salaryBudgetRepository
//      .readAll(after: anchor)
//      .forEach { try salaryBudgetRepository.deleteById($0.id) }
//    
//    // 4. 새로운 수입일에 맞춰 월급 기간 구하기
//    let (startDate, endDate) = Date.calculateStartAndEndDate(
//      from: day,
//      anchor: .now
//    )
//    
//    // 5. 새로운 수입일에 맞춰 고정 지출 날짜 새롭게 계산
//    let newFixedExpenses = initializeFixedExpense(
//      startDate: startDate,
//      endDate: endDate,
//      from: salaryBudget.fixedExpenses
//    )
//    
//    // 6. 새로운 SalaryBudget 생성
//    return try self.createSalaryBudget(
//      startDate: startDate,
//      endDate: endDate,
//      currentBalance: nil,
//      fixedIncome: salaryBudget.fixedIncome,
//      fixedExpenses: newFixedExpenses
//    )
    return SalaryBudget.default
  }
  
  func getIncomeDay() -> Int? {
    return userDefaultsRepository.readIncomeDay()
  }
}

extension FixedTransactionManagementUseCaseImpl: DefaultHarubeeCalculatable, FixedExpensesRegeneratable {}



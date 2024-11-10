//
//  BudgetUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by 신승재 on 11/6/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Shared

public final class BudgetUseCaseImpl: BudgetUseCase {
  
  private let salaryBudgetRepository: SalaryBudgetRepository
  private let dailyBudgetRepository: DailyBudgetRepository
  private let userDefaultsRepository: UserDefaultsRepository
  
  private let calendar: Calendar = .current
  
  public init(
    salaryBudgetRepository: SalaryBudgetRepository,
    dailyBudgetRepository: DailyBudgetRepository,
    userDefaultsRepository: UserDefaultsRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.dailyBudgetRepository = dailyBudgetRepository
    self.userDefaultsRepository = userDefaultsRepository
  }
  
  @discardableResult
  public func createSalaryBudget(
    startDate: Date,
    endDate: Date,
    previousExpense: Int?,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget {
    
    // 1. date 포멧 변경
    let startDate = startDate.formattedDate
    let endDate = endDate.formattedDate
    
    // 2. 총 고정 지출 금액 계산하기
    let totalFixedExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    
    // 3. 고정 수입에서 고정 지출을 뺀 금액 잔액으로 설정하기
    var initialBalance = fixedIncome - totalFixedExpenses
    
    // 3-1. 만약 온보딩에서 이전 지출 금액을 받은 경우 잔액 다시 계산하기
    if let previousExpense {
      initialBalance -= previousExpense
    }
    
    // 4. 예산 기간의 일자 개수 구하기
    let calendar = Calendar.current
    let days = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    
    // 5. 잔액을 예산 기간의 일자 개수로 나누어 기본 하루비 설정하기
    let defaultHarubee = Double(initialBalance) / Double(days)
    
    // 6. 각 날짜별로 DailyBudget 생성하기
    let dailyBudgets = (0...days).compactMap { day -> DailyBudget? in
      guard let date = calendar.date(
        byAdding: .day,
        value: day,
        to: startDate
      ) else { return nil }
      
      return DailyBudget(
        id: UUID().uuidString,
        date: date,
        harubee: nil,
        memo: [],
        expense: nil,
        income: nil
      )
    }
    
    // 7. SalaryBudget 생성하기
    let salaryBudget = SalaryBudget(
      id: UUID().uuidString,
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncome,
      fixedExpenses: fixedExpenses,
      balance: initialBalance,
      defaultHarubee: defaultHarubee,
      dailyBudgets: dailyBudgets
    )
    
    // 8. 중복되는 SalaryBudget이 있는지 찾기
    let salaryBudgets = try salaryBudgetRepository.readAll()
    if salaryBudgets.contains(
      where: { $0.startDate == salaryBudget.startDate }
    ) {
      throw DomainError.duplicateData
    }
    
    // 9. Repository에 저장하기
    salaryBudgetRepository.create(salaryBudget)
    
    return salaryBudget
  }
  
  public func getAllSalaryBudget() throws -> [SalaryBudget] {
    return try salaryBudgetRepository.readAll()
  }
  
  public func getCurrentSalaryBudget(
    date: Date?
  ) throws -> SalaryBudget {
    let targetDate = (date ?? Date()).formattedDate
    
    guard let salaryBudget = try salaryBudgetRepository.readByTargetDateContaining(targetDate) else {
      throw DomainError.dataNotFound
    }
    return salaryBudget
  }
  
  public func getSalaryBudget(
    startDate: Date?
  ) throws -> SalaryBudget {
    // 1. date 포멧 변경
    let targetDate = (startDate ?? Date()).formattedDate
    
    // 2. 특정 날짜에 해당하는 SalaryBudget 가져오기
    guard let salaryBudget = try salaryBudgetRepository.readByStartDate(targetDate) else {
      throw DomainError.dataNotFound
    }
    
    return salaryBudget
  }
  
  public func updateBalance(
    salaryBudget: SalaryBudget,
    newBalance: Int
  ) throws -> SalaryBudget {
    // 1. 새로운 잔액으로 업데이트하기
    let newSalaryBudget = try salaryBudgetRepository.updateBalance(
      salaryBudget.id,
      balance: newBalance
    )
    
    // 2. 새로 업데이트된 SalaryBudget의 잔액으로 기본 하루비 다시 계산하기
    let newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: newSalaryBudget
    )
    
    // 3. SalaryBudget에 기본 하루비 업데이트하기
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
  
  public func updateDefaultHarubee(
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    let newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: salaryBudget
    )
    
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
  

  public func updateFixedIncome(
    salaryBudget: SalaryBudget,
    newIncome: Int
  ) throws {
    
    // 1. 새로운 잔액 = oldBalance - (기존 월급 - 새로운 월급)
    let newBalance = salaryBudget.balance - (salaryBudget.fixedIncome - newIncome)
    
    // 2. 잔액이 음수가 되는지 체크하기
    guard newBalance >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 5. 기본 하루비 다시 계산하기
    let defaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: SalaryBudget(startDate: salaryBudget.startDate,
                                 endDate: salaryBudget.endDate,
                                 fixedIncome: newIncome,
                                 fixedExpenses: salaryBudget.fixedExpenses,
                                 balance: newBalance,
                                 defaultHarubee: salaryBudget.defaultHarubee,
                                 dailyBudgets: salaryBudget.dailyBudgets)
    )
    
    
    // 6. Repository 통해 저장하기
    do {
      try salaryBudgetRepository.updateSalaryBudget(
        salaryBudget.id,
        fixedIncome: .set(newIncome),
        fixedExpenses: .keep,
        balance: .set(newBalance),
        defaultHarubee: .set(defaultHarubee)
      )
    } catch DomainError.dataNotFound {
      fatalError("고정 지출 배열을 설정했으나 SalaryBudget이 없습니다.")
    }
  }
  
  public func updateFixedExpenses(
    salaryBudget: SalaryBudget,
    expenses: [TransactionItem]
  ) throws {
    
    let today = Date().formattedDate
    
    // 1. 기존 오늘 날짜 이후의 고정 지출의 합계
    let oldPostTodayTotalExpenses = salaryBudget.fixedExpenses.filter{ $0.date > today }
                                                              .reduce(0) { $0 + $1.price }
    // 2. 오늘 날짜 이후의 고정지출들의 차이(new - old)
    let postTodayDifference = expenses.filter { $0.date > today }
                                      .reduce(0) { $0 + $1.price } - oldPostTodayTotalExpenses
    
    // 3. 잔액에 반영
    let newBalance = salaryBudget.balance - postTodayDifference

    // 4. 잔액이 음수가 되는지 체크하기
    guard newBalance >= 0 else {
      throw DomainError.invalidAmount
    }
    
    
    // 5. 기본 하루비 다시 계산하기
    let defaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: SalaryBudget(startDate: salaryBudget.startDate,
                                 endDate: salaryBudget.endDate,
                                 fixedIncome: salaryBudget.fixedIncome,
                                 fixedExpenses: expenses,
                                 balance: newBalance,
                                 defaultHarubee: salaryBudget.defaultHarubee,
                                 dailyBudgets: salaryBudget.dailyBudgets)
    )
    
    // 6. Repository 통해 저장하기
    do {
      try salaryBudgetRepository.updateSalaryBudget(
        salaryBudget.id,
        fixedIncome: .keep,
        fixedExpenses: .set(expenses),
        balance: .set(newBalance),
        defaultHarubee: .set(defaultHarubee)
      )
    } catch DomainError.dataNotFound {
      fatalError("고정 지출 배열을 설정했으나 SalaryBudget이 없습니다.")
    }
  }
  
  public func calculateDefaultHarubee(salaryBudget: SalaryBudget) -> Double {
    
    let currentDate = calendar.date(
      from:calendar.dateComponents(
        [.year, .month, .day],
        from: Date()
      )
    )!
    var nilCount = 0.0
    var newBalance = Double(salaryBudget.balance)
    
    for dailyBudget in salaryBudget.dailyBudgets {
      if dailyBudget.date < currentDate { continue }
      
      if let harubee = dailyBudget.harubee { newBalance -= Double(harubee) }
      else { nilCount += 1 }
    }
    
    return nilCount == 0.0 ? newBalance : newBalance / nilCount
  }
  
  public func calculateAverageHarubee(endDate: Date, balance: Int) -> Double {
    let currentDate = calendar.date(
      from:calendar.dateComponents(
        [.year, .month, .day],
        from: Date()
      )
    )!
    let secondsInDay = 86400.0
    let remain = endDate.timeIntervalSince(currentDate) / secondsInDay + 1
    
    return Double(balance) / remain
  }
  
  
  public func getDailyBudget(
    date: Date
  ) throws -> DailyBudget {
    // 1. 오늘에 해당하는 DailyBudget 찾기
    guard let budget = try dailyBudgetRepository.readByDate(date.formattedDate) else {
      throw DomainError.dataNotFound
    }
    
    // 2. DailyBudget 반환하기
    return budget
  }
  
  public func adjustHarubee(
    amount: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget) {
    
    let date = date.formattedDate
    guard date >= salaryBudget.startDate
            && date <= salaryBudget.endDate else {
      throw DomainError.dateOutOfRange
    }
    
    var salaryBudget = salaryBudget
    
    // 1. DailyBudget 찾기
    guard let index = salaryBudget.dailyBudgets.firstIndex(where: {
      $0.date == date.formattedDate
    }) else { throw DomainError.dataNotFound }
    
    // 2. SalaryBudget에서 해당 날짜의 DailyBudget 하루비 업데이트
    salaryBudget.dailyBudgets[index].harubee = amount
    
    // 3. DailyBudget 업데이트
    let newDailyBudget = try dailyBudgetRepository.updateHarubee(
      salaryBudget.dailyBudgets[index].id,
      harubee: amount
    )

    // 4. SalaryBudget의 기본하루비 업데이트
    let newSalaryBudget = try self.updateDefaultHarubee(salaryBudget: salaryBudget)
    
    return (newDailyBudget, newSalaryBudget)
  }
  
  
  public func recordTransaction(
    expense: Int?,
    income: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget) {
    
    // 1. 날짜 유효성 검사
    let date = date.formattedDate
    guard date >= salaryBudget.startDate
            && date <= salaryBudget.endDate else {
      throw DomainError.dateOutOfRange
    }
    
    // 2. SalaryBudget 내에서 dailyBudget의 index 찾기
    guard let index = salaryBudget.dailyBudgets.firstIndex(where: {
      $0.date == date.formattedDate
    }) else { throw DomainError.dataNotFound }
    
    // 3. 실제 지출 변경 전, 후, 차액 저장
    let previousExpense = salaryBudget.dailyBudgets[index].expense ?? 0
    let currentExpense = expense ?? 0
    let diffExpense = currentExpense - previousExpense
    
    // 4. 수입 변경 전, 후, 차액 저장
    let previousIncome = salaryBudget.dailyBudgets[index].income ?? 0
    let currentIncome = income ?? 0
    let diffIncome = currentIncome - previousIncome
    
    // 5. DailyBudget 업데이트 (실제 지출, 수입 기록)
    let newDailyBudget = try dailyBudgetRepository.updateTransaction(
      salaryBudget.dailyBudgets[index].id,
      expense: currentExpense,
      income: currentIncome
    )
    
    // 6. 잔액 업데이트
    let newBalance = salaryBudget.balance - diffExpense + diffIncome
    
    // 7. SalaryBudget 업데이트
    let newSalaryBudget = try self.updateBalance(
      salaryBudget: salaryBudget,
      newBalance: newBalance
    )
    
    return (newDailyBudget, newSalaryBudget)
  }
  
  
  public func updateMemoList(
    memoList: [String],
    dailyBudget: DailyBudget
  ) throws -> DailyBudget {
    
    return try dailyBudgetRepository.updateMemo(
      dailyBudget.id,
      memo: memoList
    )
  }
  
  
  public func setIncomeDay(
    day: Int,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    let today = Date().formattedDate
    
    // 1. 월급일이 1일부터 31일 사이에 속하는지 확인하기
    guard (1...31).contains(day) else {
      throw DomainError.dateOutOfRange
    }
    
    // 2. UserDefaults에 설정하기
    try userDefaultsRepository.saveIncomeDay(day)
    
    // 3. 새로운 SalaryBudget을 위한 데이트 계산하기
    var incomeStartDate: Date {
      var components = calendar.dateComponents([.year, .month, .day], from: today)
      if components.day! < day {
        components.month! -= 1
      }
      components.day! = day
      let startDate = calendar.date(from: components)!
      return startDate
    }
    
    var incomeEndDate: Date {
      // startDate가 한 달의 시작 날짜가 됩니다.
      let startDate = incomeStartDate
      // startDate의 일자(day)를 기준으로 한 달 후의 날짜를 구함
      var components = calendar.dateComponents([.year, .month, .day], from: startDate)
      components.month! += 1 // 한 달 뒤로 설정
      // 다음 달에 동일한 일자가 있는지 확인하여 날짜를 생성
      if let calculatedEndDate = calendar.date(from: components) {
        return calculatedEndDate.addingTimeInterval(-86400)
      } else {
        // 동일 일자가 없는 경우(예: 30일이나 31일이 없는 달) 해당 월의 마지막 날로 조정
        var fallbackComponents = components
        fallbackComponents.day = calendar.range(of: .day, in: .month, for: calendar.date(from: components)!)?.last
        return calendar.date(from: fallbackComponents)!
      }
    }
    
    // 4.  기존 salaryBudget 삭제하기
    try salaryBudgetRepository.deleteById(salaryBudget.id)
    
    // 5. 새로운 SalaryBudget 생성
    return try self.createSalaryBudget(startDate: incomeStartDate,
                                endDate: incomeEndDate,
                                previousExpense: 0,
                                fixedIncome: salaryBudget.fixedIncome,
                                fixedExpenses: salaryBudget.fixedExpenses)
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
}


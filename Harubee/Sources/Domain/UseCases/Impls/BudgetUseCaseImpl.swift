//
//  BudgetUseCaseImpl.swift
//  Harubee-iOS
//
//  Created by 신승재 on 11/6/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

final class BudgetUseCaseImpl: BudgetUseCase {
  
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
  
  // MARK: - SalaryBudget Function
  
  @discardableResult
  func createSalaryBudget(
    startDate: Date,
    endDate: Date,
    currentBalance: Int?,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget {
    // 1. date 포멧 변경
    let startDate = startDate.formattedDate
    let endDate = endDate.formattedDate
    
    // 2. 중복되는 SalaryBudget이 있으면 에러
    guard try salaryBudgetRepository.readByStartDate(startDate) == nil else {
      throw DomainError.duplicateData
    }
    
    // 3. SalaryBudget 생성하기
    let salaryBudget = initializeSalaryBudget(
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncome,
      fixedExpenses: fixedExpenses,
      balance: currentBalance ?? fixedIncome
    )
    
    // 4. Repository에 저장하기
    salaryBudgetRepository.create(salaryBudget)
    
    // 5. 필요하다면 다음달의 salaryBudget 생성
    try createNextSalaryBudgetIfNeeded(salaryBudget: salaryBudget)
    
    return salaryBudget
  }
  
  func getAllSalaryBudget() throws -> [SalaryBudget] {
    return try salaryBudgetRepository.readAll()
  }
  
  func getCurrentSalaryBudget(
    date: Date?
  ) throws -> SalaryBudget {
    let targetDate = (date ?? Date()).formattedDate
    
    guard let salaryBudget = try salaryBudgetRepository.readByTargetDateContaining(
      targetDate
    ) else {
      throw DomainError.dataNotFound
    }
    
    // 다음 기간에 해당하는 SalaryBudget이 있는지 확인 후 생성
    try createNextSalaryBudgetIfNeeded(salaryBudget: salaryBudget)
    
    // 이전 날짜에 입력되지 않은 하루비가 있는지 확인 후 값 설정
    return try updateHarubeeForPastDates(salaryBudget)
  }
  
  func updateBalance(
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
      salaryBudget: newSalaryBudget,
      anchorDate: .now
    )
    
    // 3. SalaryBudget에 기본 하루비 업데이트하기
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
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
        : initializeFixedExpense(
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
  
  func calculateDefaultHarubee(
    salaryBudget: SalaryBudget,
    anchorDate: Date
  ) -> Double {
    // 1. 하루비 계산의 기준 날짜 포멧팅
    let currentDate = anchorDate.formattedDate
    
    var nilCount = 0 // 하루비를 조정하지 않은 날짜 개수
    var newBalance = Double(salaryBudget.balance) // 현재 잔액에서 조정된 하루비 금액을 차감하는데 사용됨
    
    // SalaryBudget의 모든 DailyBudget을 순회
    for dailyBudget in salaryBudget.dailyBudgets {
      // dailyBudget의 날짜가 (하루비 계산의)기준 날짜보다 이전이거나,
      // 해당 날짜에 지출을 입력하지 않은 경우는 건너뜀
      if dailyBudget.date < currentDate
          || dailyBudget.expense != nil {
        continue
      }
      
      // 하루비를 조정했다면 현재 잔액에서 차감
      // 그렇지 않다면 nilCount 증가
      if let harubee = dailyBudget.harubee { newBalance -= Double(harubee) }
      else { nilCount += 1 }
    }
    
    // nilCount == 0 -> 모든 날짜의 하루비를 조정함 -> 차감된 최종 잔액 리턴
    // 그렇지 않음 -> 일부 날짜만 하루비 조정 -> 차감된 잔액을 조정하지 않은 날짜의 개수만큼 나눔
    return nilCount == 0
    ? newBalance
    : newBalance / Double(nilCount)
  }
  
  func deleteAllSalaryBudgets() throws {
    try salaryBudgetRepository.deleteAll()
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
    
    // 4. 새로운 수입일에 맞춰 월급 기간 구하기
    let (startDate, endDate) = Date.calculateStartAndEndDate(
      from: day,
      anchor: .now
    )
    
    // 5. 새로운 수입일에 맞춰 고정 지출 날짜 새롭게 계산
    let newFixedExpenses = initializeFixedExpense(
      startDate: startDate,
      endDate: endDate,
      from: salaryBudget.fixedExpenses
    )
    
    // 6. 새로운 SalaryBudget 생성
    return try self.createSalaryBudget(
      startDate: startDate,
      endDate: endDate,
      currentBalance: nil,
      fixedIncome: salaryBudget.fixedIncome,
      fixedExpenses: newFixedExpenses
    )
  }
  
  func setIncomeDay(day: Int) {
    userDefaultsRepository.saveIncomeDay(day)
  }
  
  func getIncomeDay() -> Int? {
    return userDefaultsRepository.readIncomeDay()
  }
  
  // MARK: - DailyBudget Function
  func getDailyBudget(
    date: Date
  ) throws -> DailyBudget {
    // 1. 오늘에 해당하는 DailyBudget 찾기
    guard let budget = try dailyBudgetRepository.readByDate(
      date.formattedDate
    ) else {
      throw DomainError.dataNotFound
    }
    
    // 2. DailyBudget 반환하기
    return budget
  }
  
  func adjustHarubee(
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
    let newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: salaryBudget,
      anchorDate: .now
    )
    let newSalaryBudget = try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
    
    return (newDailyBudget, newSalaryBudget)
  }
  
  
  func recordTransaction(
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
    
    // 5. 지출, 수입 입력 시점에 DailyBudget의 하루비가 nil인 경우, 기본 하루비로 저장
    let harubee = salaryBudget.dailyBudgets[index].harubee ?? Int(salaryBudget.defaultHarubee)
      
    let newDailyBudget = try dailyBudgetRepository.updateDailyBudget(
      salaryBudget.dailyBudgets[index].id,
      harubee: .set(harubee),
      expence: .set(currentExpense),
      income: .set(currentIncome),
      memo: .keep
    )
    
    // 7. 잔액 업데이트
    let newBalance = salaryBudget.balance - diffExpense + diffIncome
    
    // 8. SalaryBudget 업데이트
    let newSalaryBudget = try self.updateBalance(
      salaryBudget: salaryBudget,
      newBalance: newBalance
    )
    
    return (newDailyBudget, newSalaryBudget)
  }
  
  
  func updateMemoList(
    memoList: [String],
    dailyBudget: DailyBudget
  ) throws -> DailyBudget {
    
    return try dailyBudgetRepository.updateMemo(
      dailyBudget.id,
      memo: memoList
    )
  }
}

// MARK: - Private Function
private extension BudgetUseCaseImpl {
  /// 초기 SalaryBudget을 생성합니다
  /// - Parameters:
  ///   - startDate: 시작 날짜
  ///   - endDate: 종료 날짜
  ///   - fixedIncome: 고정 수입
  ///   - fixedExpenses: 고정 지출 내역
  ///   - balance: 계산된 현재 잔액
  /// - Returns: SalaryBudget
  func initializeSalaryBudget(
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem],
    balance: Int
  ) -> SalaryBudget {
    // 남은 기간의 일자 개수 구하기
    // 온보딩 : 오늘부터, 메인 : 시작 날짜부터
    let today = Date().formattedDate
    let anchor = max(startDate, today)
    let days = anchor.daysUntil(endDate)
    
    // 고정 지출 금액 뺀 잔액 구하기
    let initialBalance = calculateInitialBalance(
      current: balance,
      items: fixedExpenses,
      from: anchor
    )
    
    // 기본 하루비 구하기
    let defaultHarubee = Double(initialBalance) / Double(days + 1)
    
    // DailyBudgets 생성
    let dailyBudgets = initializeDailyBudgets(
      startDate: startDate,
      endDate: endDate
    )
    
    // SalaryBudget 생성
    return SalaryBudget(
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncome,
      fixedExpenses: fixedExpenses,
      balance: initialBalance,
      defaultHarubee: defaultHarubee,
      dailyBudgets: dailyBudgets
    )
  }
  
  /// SalaryBudget에 들어갈 초기 DailyBudgets을 생성합니다
  /// - Parameters:
  ///   - startDate: 시작 날짜
  ///   - endDate: 종료 날짜
  /// - Returns: [DailyBudget]
  func initializeDailyBudgets(
    startDate: Date,
    endDate: Date
  ) -> [DailyBudget] {
    let totalDays = startDate.daysUntil(endDate)
    let today = Date().formattedDate
    
    return (0...totalDays).compactMap { day -> DailyBudget? in
      guard let date = startDate.adding(
        by: .day, value: day
      ) else { return nil }
      
      // TODO: harubee, expense 설정 수정 필요
      // Ex) 1, 2월이 이미 생성된 상태에서 3월 중간에 접속했을 때
      // 3, 4월 데이터를 생성하는 과정에서 아래와 같이 조건을 설정하면
      // 3월 초반 날짜에 접근 불가
      // UserDefaults의 isOnboarding을 확인해서 처리
      return DailyBudget(
        date: date,
        harubee: date < today ? -1 : nil,
        memo: [],
        expense: date < today ? -1 : nil,
        income: nil
      )
    }
  }
  
  /// 이후에 빠져나갈 고정 지출 금액을 뺀 잔액을 구합니다
  /// - Parameters:
  ///   - current: 현재 잔액
  ///   - items: 고정 지출 내역
  ///   - anchor: 계산될 고정 지출 내역의 기준 날짜
  /// - Returns: 계산된 남은 잔액
  func calculateInitialBalance(
    current: Int,
    items: [TransactionItem],
    from anchor: Date
  ) -> Int {
    // anchor가 오늘 날짜 이전인 경우 = 모든 고정 지출 내역 차감
    // anchor가 오늘 날짜인 경우 = 오늘 이후의 고정 지출 내역만 차감
    let anchorDate = anchor.isToday
    ? anchor
    : anchor.adding(by: .day, value: -1)!
    
    // TODO: 계산될 고정 지출 내역 기준 설정 수정 필요
    // Ex) 1, 2월이 이미 생성된 상태에서 3월 중간에 접속했을 때
    // 3, 4월 데이터를 생성하는 과정에서 아래와 같이 조건을 설정하면
    // 초반 고정 지출 내역은 차감되지 않음
    let totalFixedExpenses = items
      .filter { $0.date > anchorDate }
      .reduce(0) { $0 + $1.price }
    
    return current - totalFixedExpenses
  }
  
  /// 이전 고정 지출 내역을 가지고 새로운 고정 지출 내역을 생성합니다
  /// - Parameters:
  ///   - startDate: 시작 날짜
  ///   - endDate: 종료 날짜
  ///   - fixedExpenses: 이전 고정 지출 내역
  /// - Returns: 새로운 고정 지출 내역
  func initializeFixedExpense(
    startDate: Date,
    endDate: Date,
    from fixedExpenses: [TransactionItem]
  ) -> [TransactionItem] {
    return fixedExpenses.map {
      let date = Date.convertDateBetweenStartAndEnd(
        start: startDate,
        end: endDate,
        day: $0.day
      )
      
      return TransactionItem(
        date: date,
        day: $0.day,
        name: $0.name,
        price: $0.price
      )
    }
  }
  
  /// 다음 월급 달의 SalaryBudget을 생성합니다.
  /// - Parameter salaryBudget: 현재 SalaryBudget
  /// - `DomainError.dataNotFound`: IncomeDay를 찾을 수 없는 경우
  func createNextSalaryBudgetIfNeeded(
    salaryBudget: SalaryBudget
  ) throws {
    
    // 1. 이번 기간 이후 SalaryBudget이 존재한다면 리턴
    let nextDate = salaryBudget.endDate.adding(by: .day, value: 1)!
    guard try salaryBudgetRepository.readByStartDate(nextDate) == nil else { return }
    
    // 2. incomeDay 가져오기
    guard let incomeDay = getIncomeDay() else {
      throw DomainError.dataNotFound
    }
    
    // 3. 다음 달의 SalaryBudget StartDate, EndDate 계산
    let (nextStartDate, nextEndDate) = Date.calculateStartAndEndDate(
      from: incomeDay,
      anchor: nextDate
    )
    
    // 4. 고정지출 생성
    let nextFixedExpenses = initializeFixedExpense(
      startDate: nextStartDate,
      endDate: nextEndDate,
      from: salaryBudget.fixedExpenses
    )
    
    // 5. SalaryBudget 생성
    let nextSalaryBudget = initializeSalaryBudget(
      startDate: nextStartDate,
      endDate: nextEndDate,
      fixedIncome: salaryBudget.fixedIncome,
      fixedExpenses: nextFixedExpenses,
      balance: salaryBudget.fixedIncome
    )
    
    // 6. 저장하기
    salaryBudgetRepository.create(nextSalaryBudget)
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

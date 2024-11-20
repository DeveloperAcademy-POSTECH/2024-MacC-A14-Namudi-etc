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
  
  private let calendar: Calendar = .current
  
  init(
    salaryBudgetRepository: SalaryBudgetRepository,
    dailyBudgetRepository: DailyBudgetRepository,
    userDefaultsRepository: UserDefaultsRepository
  ) {
    self.salaryBudgetRepository = salaryBudgetRepository
    self.dailyBudgetRepository = dailyBudgetRepository
    self.userDefaultsRepository = userDefaultsRepository
  }
  
  @discardableResult
  func createSalaryBudgetFromOnboarding(
    startDate: Date,
    endDate: Date,
    previousExpense: Int?,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget {
    // 1. date 포멧 변경
    let startDate = startDate.formattedDate
    let endDate = endDate.formattedDate
    let today = Date().formattedDate
    
    // 2. 총 고정 지출 금액 계산하기
    let totalFixedExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    
    // 3. 고정 수입에서 고정 지출을 뺀 금액 잔액으로 설정하기
    var initialBalance = fixedIncome - totalFixedExpenses
    
    // 3-1. 만약 이전 지출 금액을 받은 경우 잔액 다시 계산하기
    if let previousExpense {
      initialBalance -= previousExpense
    }
    
    // 4. 남은 기간의 일자 개수 구하기 (오늘부터 endDate까지)
    let calendar = Calendar.current
    let remainingDays = calendar.dateComponents(
      [.day],
      from: today,
      to: endDate
    ).day ?? 0
    
    // 5. 잔액을 남은 기간의 일자 개수로 나누어 기본 하루비 설정하기
    let defaultHarubee = Double(initialBalance) / Double(remainingDays + 1)
    
    // 6. 각 날짜별로 DailyBudget 생성하기
    let days = calendar.dateComponents(
      [.day],
      from: startDate,
      to: endDate
    ).day ?? 0
    
    let dailyBudgets = (0...days).compactMap { day -> DailyBudget? in
      guard let date = calendar.date(
        byAdding: .day,
        value: day,
        to: startDate
      ) else { return nil }
      
      return DailyBudget(
        id: UUID().uuidString,
        date: date,
        harubee: date < today ? 0 : nil,
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
    
    // 8. Repository에 저장하기
    salaryBudgetRepository.create(salaryBudget)
    
    return salaryBudget
  }
  
  @discardableResult
  func createSalaryBudget(
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget {
    // 1. date 포멧 변경
    let startDate = startDate.formattedDate
    let endDate = endDate.formattedDate
    
    // 2. 총 고정 지출 금액 계산하기
    let totalFixedExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    
    // 3. 고정 수입에서 고정 지출을 뺀 금액 잔액으로 설정하기
    let initialBalance = fixedIncome - totalFixedExpenses
    
    // 4. 남은 기간의 일자 개수 구하기
    let calendar = Calendar.current
    let days = calendar.dateComponents(
      [.day],
      from: startDate,
      to: endDate
    ).day ?? 0
    
    // 5. 잔액을 예산 기간의 일자 개수로 나누어 기본 하루비 설정하기
    let defaultHarubee = Double(initialBalance) / Double(days + 1)
    
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
    return salaryBudget
  }
  
  func getSalaryBudget(
    startDate: Date?
  ) throws -> SalaryBudget {
    // 1. date 포멧 변경
    let targetDate = (startDate ?? Date()).formattedDate
    
    // 2. 특정 날짜에 해당하는 SalaryBudget 가져오기
    guard let salaryBudget = try salaryBudgetRepository.readByStartDate(
      targetDate
    ) else {
      throw DomainError.dataNotFound
    }
    
    return salaryBudget
  }
  
  
  // TODO: updateBalance와 updateDefaultHarubee 분리 필요
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
  
  func updateDefaultHarubee(
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    let newDefaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: salaryBudget,
      anchorDate: .now
    )
    
    return try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: newDefaultHarubee
    )
  }
  
  
  func updateFixedIncome(
    salaryBudget: SalaryBudget,
    newIncome: Int
  ) throws -> SalaryBudget {
    
    // 1. 새로운 잔액 = oldBalance - (기존 월급 - 새로운 월급)
    let newBalance = salaryBudget.balance - (salaryBudget.fixedIncome - newIncome)
    
    // 2. 잔액이 음수가 되는지 체크하기
    guard newBalance >= 0 else {
      throw DomainError.invalidAmount
    }
    
    // 5. 기본 하루비 다시 계산하기
    let defaultHarubee = self.calculateDefaultHarubee(
      salaryBudget: SalaryBudget(
        startDate: salaryBudget.startDate,
        endDate: salaryBudget.endDate,
        fixedIncome: newIncome,
        fixedExpenses: salaryBudget.fixedExpenses,
        balance: newBalance,
        defaultHarubee: salaryBudget.defaultHarubee,
        dailyBudgets: salaryBudget.dailyBudgets
      ),
      anchorDate: .now
    )
    
    // 6. Repository 통해 저장하기
    do {
      return try salaryBudgetRepository.updateSalaryBudget(
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
  
  func updateFixedExpenses(
    salaryBudget: SalaryBudget,
    expenses: [TransactionItem]
  ) throws -> SalaryBudget {
    
    let today = Date().formattedDate
    
    // 1. 기존 오늘 날짜 이후의 고정 지출의 합계
    let oldPostTodayTotalExpenses = salaryBudget.fixedExpenses
      .filter{ $0.date > today }
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
      salaryBudget: SalaryBudget(
        startDate: salaryBudget.startDate,
        endDate: salaryBudget.endDate,
        fixedIncome: salaryBudget.fixedIncome,
        fixedExpenses: expenses,
        balance: newBalance,
        defaultHarubee: salaryBudget.defaultHarubee,
        dailyBudgets: salaryBudget.dailyBudgets
      ),
      anchorDate: .now
    )
    
    // 6. Repository 통해 저장하기
    do {
      return try salaryBudgetRepository.updateSalaryBudget(
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
  
  func calculateDefaultHarubee(
    salaryBudget: SalaryBudget,
    anchorDate: Date
  ) -> Double {
    
    let currentDate = anchorDate.formattedDate
    
    var nilCount = 0.0
    var newBalance = Double(salaryBudget.balance)
    
    for dailyBudget in salaryBudget.dailyBudgets {
      if dailyBudget.date < currentDate || dailyBudget.expense != nil {
        continue
      }
      
      if let harubee = dailyBudget.harubee { newBalance -= Double(harubee) }
      else { nilCount += 1 }
    }
    
    return nilCount == 0.0 ? newBalance : newBalance / nilCount
  }
  
  func calculateAverageHarubee(endDate: Date, balance: Int) -> Double {
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
    let newSalaryBudget = try self.updateDefaultHarubee(salaryBudget: salaryBudget)
    
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
  
  
  func setIncomeDay(
    day: Int,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget {
    
    // 1. 월급일이 1일부터 31일 사이에 속하는지 확인하기
    guard (1...31).contains(day) else {
      throw DomainError.dateOutOfRange
    }
    
    // 2. UserDefaults에 설정하기
    try userDefaultsRepository.saveIncomeDay(day)
    
    let (startDate, endDate) = Date.calculateStartAndEndDate(from: day)
    
    // 4.  기존 salaryBudget 삭제하기
    try salaryBudgetRepository.deleteById(salaryBudget.id)
    
    // 5. 새로운 SalaryBudget 생성
    return try self.createSalaryBudget(
      startDate: startDate,
      endDate: endDate,
      fixedIncome: salaryBudget.fixedIncome,
      fixedExpenses: salaryBudget.fixedExpenses
    )
  }
  
  
  func getIncomeDay() throws -> Int {
    
    // 1. 월급일을 가져오고 저장된 월급일이 없으면 기본값 1로 설정하기
    guard let incomeDay = userDefaultsRepository.readIncomeDay() else {
      try userDefaultsRepository.saveIncomeDay(1)
      return 1
    }
    
    return incomeDay
  }
  
  func setTodayHarubeeNotificationTime(time: Date) {
    try? userDefaultsRepository.saveTodayHarubeeNotificationTime(time)
  }

  func getTodayHarubeeNotificationTime() -> Date? {
    // 지정된 알림 시간을 가져오고 저장된 알림 시간이 없으면 9:00 AM으로 설정하기
    guard let time = userDefaultsRepository.readTodayHarubeeNotificationTime()
    else {
      var dateComponents = DateComponents()
      dateComponents.hour = 9
      dateComponents.minute = 0
      
      return calendar.date(from: dateComponents)
    }
    
    return time
  }

  func setExpenseNotificationTime(time: Date) {
    try? userDefaultsRepository.saveExpenseNotificationTime(time)
  }

  func getExpenseNotificationTime() -> Date? {
    // 지정된 알림 시간을 가져오고 저장된 알림 시간이 없으면 10:00 PM으로 설정하기
    guard let time = userDefaultsRepository.readExpenseNotificationTime()
    else {
      var dateComponents = DateComponents()
      dateComponents.hour = 22
      dateComponents.minute = 0
      
      return calendar.date(from: dateComponents)
    }
    
    return time
  }
  
  // TODO: 함수명, 로직 수정 필요
  func checkSalaryBudget(_ salaryBudget: SalaryBudget) throws -> SalaryBudget {
    var salaryBudget = salaryBudget
    
    let today = Date().formattedDate
    var index = 0
    
    // 1. 최근 접속 날짜 불러오기
    let recentAccessDay = UserDefaults.standard.object(
      forKey: "recentAccessDay"
    ) as? Date ?? today
    
    // 최근 접속 날짜 업데이트
    UserDefaults.standard.set(today, forKey: "recentAccessDay")
    
    // 2. 최근 접속 날짜가 오늘 날짜와 일치한 경우, 기존 salaryBudget 리턴
    if recentAccessDay.isToday { return salaryBudget }
    
    // 3.
    while salaryBudget.dailyBudgets[index].date != today {
      let dailyBudget = salaryBudget.dailyBudgets[index]
      
      // dailyBudget의 하루비가 nil이 아닌 경우, 건너뜀
      if dailyBudget.harubee != nil {
        index += 1
        continue
      }
      
      // dailyBudget의 하루비를 기본 하루비로 업데이트
      salaryBudget.dailyBudgets[index] = try dailyBudgetRepository.updateHarubee(
        dailyBudget.id,
        harubee: Int(salaryBudget.defaultHarubee)
      )
      
      // salaryBudget의 기본 하루비 업데이트
      let defaultHarubee = self.calculateDefaultHarubee(
        salaryBudget: salaryBudget,
        anchorDate: dailyBudget.date.addingTimeInterval(86400)
      )
      salaryBudget.defaultHarubee = defaultHarubee
      
      index += 1
    }
    
    try salaryBudgetRepository.updateDefaultHarubee(
      salaryBudget.id,
      defaultHarubee: salaryBudget.defaultHarubee
    )
    
    return salaryBudget
  }
}







import Foundation

extension Date {
  static func createDate(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.second = 0
    
    return Calendar.current.date(from: components) ?? Date()
  }
}

enum SampleError: LocalizedError {
  case testError
  case invalidDateRange
  
  var errorDescription: String? {
    switch self {
    case .testError:
      return "테스트 에러가 발생했습니다."
    case .invalidDateRange:
      return "유효하지 않은 날짜 범위입니다."
    }
  }
}

class SampleDataGenerator {
  // MARK: - Constants
  private static let calendar = Calendar.current
  private static let fixedIncomeAmount = 2_000_000 // 200만원 월급
  private static let minimumExpense = 5_000 // 최소 지출액
  private static let maximumExpense = 50_000 // 최대 지출액
  private static let weekendExpenseMultiplier = 1.5 // 주말 지출 증가 비율
  private static let defaultHarubeeRange = 20_000...35_000 // 하루비 조정 범위
  
  // MARK: - Helper Methods
  private static func calculateBudgetEndDate(from startDate: Date) -> Date {
    // 시작일의 다음달 같은 날짜의 전날이 종료일
    guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: startDate),
          let endDate = calendar.date(byAdding: .day, value: -1, to: nextMonth) else {
      return startDate
    }
    return endDate
  }
  
  private static func generateFixedExpenses(startDate: Date) -> [TransactionItem] {
    let utilityDay = 15 // 통신비는 매달 15일
    let subscriptionDay = 25 // 구독서비스는 매달 25일
    
    var expenses: [TransactionItem] = []
    
    // 해당 월의 1일 계산
    let components = calendar.dateComponents([.year, .month], from: startDate)
    guard let firstDayOfMonth = calendar.date(from: components) else { return [] }
    
    // 월세 (매달 1일)
    expenses.append(TransactionItem(
      date: firstDayOfMonth,
      name: "월세",
      price: 500_000
    ))
    
    // 통신비
    if let utilityDate = calendar.date(bySetting: .day, value: utilityDay, of: firstDayOfMonth) {
      expenses.append(TransactionItem(
        date: utilityDate,
        name: "통신비",
        price: 50_000
      ))
    }
    
    // 구독서비스
    if let subscriptionDate = calendar.date(bySetting: .day, value: subscriptionDay, of: firstDayOfMonth) {
      expenses.append(TransactionItem(
        date: subscriptionDate,
        name: "구독서비스",
        price: 30_000
      ))
    }
    
    // 시작일 이후의 고정 지출만 반환
    return expenses.filter { $0.date >= startDate }
  }
  
  private static func generateExpenseForDate(_ date: Date, isWeekend: Bool) -> Int? {
    if date > Date() {
      return nil // 미래 날짜는 지출이 없음
    }
    
    let baseExpense = Int.random(in: minimumExpense...maximumExpense)
    return isWeekend ? Int(Double(baseExpense) * weekendExpenseMultiplier) : baseExpense
  }
  
  private static func calculateDefaultHarubee(
    balance: Int,
    dailyBudgets: [DailyBudget],
    currentDate: Date,
    endDate: Date
  ) -> Double {
    // 하루비가 설정되지 않은 미래 날짜들 필터링
    let futureBudgetsWithoutHarubee = dailyBudgets.filter { budget in
      budget.date > currentDate &&
      budget.date <= endDate &&
      budget.harubee == nil
    }
    
    // 하루비가 설정된 미래 날짜들의 하루비 총합
    let futureHarubeeSum = dailyBudgets
      .filter { $0.date > currentDate && $0.date <= endDate && $0.harubee != nil }
      .compactMap { $0.harubee }
      .reduce(0, +)
    
    // 실제 남은 잔액 (설정된 하루비들을 제외)
    let remainingBalance = balance - futureHarubeeSum
    
    // 하루비가 설정되지 않은 날짜 수로 나누기
    let remainingDays = futureBudgetsWithoutHarubee.count
    return remainingDays > 0 ? Double(remainingBalance) / Double(remainingDays) : 0
  }
  
  // MARK: - Public Methods
  static func createSampleSalaryBudget(withError: Bool = false, startDate: Date) throws -> SalaryBudget {
    if withError {
      throw SampleError.testError
    }
    
    let endDate = calculateBudgetEndDate(from: startDate)
    if endDate <= startDate {
      throw SampleError.invalidDateRange
    }
    
    // 1. 고정 지출 생성
    let fixedExpenses = generateFixedExpenses(startDate: startDate)
    
    // 2. 초기 잔액 계산 (월급 - 고정지출)
    let totalFixedExpenses = fixedExpenses.reduce(0) { $0 + $1.price }
    var currentBalance = fixedIncomeAmount - totalFixedExpenses
    
    // 3. 일별 예산 생성
    var dailyBudgets: [DailyBudget] = []
    var currentDate = startDate
    let today = Date()
    
    while currentDate <= endDate {
      let isWeekend = calendar.isDateInWeekend(currentDate)
      let isPastOrToday = currentDate <= today
      
      // 하루비 조정 확률 (과거: 80%, 미래: 20%)
      let shouldAdjustHarubee = isPastOrToday ?
      Double.random(in: 0...1) > 0.2 :
      Double.random(in: 0...1) > 0.8
      
      let adjustedHarubee = shouldAdjustHarubee ? Int.random(in: defaultHarubeeRange) : nil
      
      // 지출과 수입 생성
      let expense = generateExpenseForDate(currentDate, isWeekend: isWeekend)
      let income = isPastOrToday && Bool.random() ?
      Int.random(in: 10_000...100_000) : nil
      
      // 실제 지출/수입 반영하여 잔액 업데이트
      if let expense = expense {
        currentBalance -= expense
      }
      if let income = income {
        currentBalance += income
      }
      
      let dailyBudget = DailyBudget(
        date: currentDate,
        harubee: adjustedHarubee,
        memo: isPastOrToday ? generateSampleMemos(isHarubeeAdjusted: shouldAdjustHarubee) : [],
        expense: expense,
        income: income
      )
      
      dailyBudgets.append(dailyBudget)
      
      guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
      currentDate = nextDate
    }
    
    // 4. 기본 하루비 계산
    let defaultHarubee = calculateDefaultHarubee(
      balance: currentBalance,
      dailyBudgets: dailyBudgets,
      currentDate: today,
      endDate: endDate
    )
    
    return SalaryBudget(
      id: UUID().uuidString,
      startDate: startDate,
      endDate: endDate,
      fixedIncome: fixedIncomeAmount,
      fixedExpenses: fixedExpenses,
      balance: currentBalance,
      defaultHarubee: defaultHarubee,
      dailyBudgets: dailyBudgets
    )
  }
  
  static func createMultipleSampleBudgets(withError: Bool = false) throws -> [SalaryBudget] {
    if withError {
      throw SampleError.testError
    }
    
    var allBudgets: [SalaryBudget] = []
    let today = Date()
    
    // 기준이 되는 날짜 설정 (오늘이 포함된 급여 기간의 시작일)
    let incomeDay = 20 // 매달 20일이 월급일
    let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
    
    guard let baseDate = calendar.date(from: todayComponents) else {
      throw SampleError.invalidDateRange
    }
    
    // 오늘이 포함된 급여 기간의 시작일 계산
    let currentPeriodStart: Date
    if todayComponents.day! >= incomeDay {
      currentPeriodStart = calendar.date(bySetting: .day, value: incomeDay, of: baseDate) ?? baseDate
    } else {
      guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: baseDate) else {
        throw SampleError.invalidDateRange
      }
      currentPeriodStart = calendar.date(bySetting: .day, value: incomeDay, of: previousMonth) ?? previousMonth
    }
    
    // 과거 12개월, 미래 12개월의 예산 생성 (총 25개 - 현재 포함)
    for monthOffset in -12...12 {
      guard let periodStart = calendar.date(byAdding: .month, value: monthOffset, to: currentPeriodStart) else {
        continue
      }
      
      let budget = try createSampleSalaryBudget(startDate: periodStart)
      allBudgets.append(budget)
    }
    
    return allBudgets.sorted { $0.startDate < $1.startDate }
  }
  
  // MARK: - Sample Data Helpers
  private static func generateSampleMemos(isHarubeeAdjusted: Bool) -> [String] {
    // 하루비가 조정된 날은 80% 확률로 메모 있음
    // 하루비가 조정되지 않은 날은 20% 확률로 메모 있음
    let shouldHaveMemo = Double.random(in: 0...1) > (isHarubeeAdjusted ? 0.2 : 0.8)
    guard shouldHaveMemo else { return [] }
    
    // 하루비 증가와 관련된 메모들
    let increasedHarubeeMemos = [
      "친구들과 회식",
      "영화 + 술약속",
      "동기들 만나는 날",
      "생일 파티",
      "데이트",
      "콘서트 가는 날",
      "모임있는 날"
    ]
    
    // 하루비 감소와 관련된 메모들
    let decreasedHarubeeMemos = [
      "재택근무",
      "휴식",
      "집콕",
      "야근",
      "운동하는 날",
      "공부하는 날"
    ]
    
    // 일반적인 메모들
    let normalMemos = [
      "장보기",
      "카페가기",
      "병원가기",
      "운동",
      "독서"
    ]
    
    var availableMemos = normalMemos
    if isHarubeeAdjusted {
      // 하루비가 조정된 날에는 증가/감소 관련 메모 추가
      availableMemos = Bool.random() ? increasedHarubeeMemos : decreasedHarubeeMemos
    }
    
    let memoCount = isHarubeeAdjusted ?
    Int.random(in: 1...2) : // 하루비 조정된 날은 1-2개
    1 // 일반적인 날은 1개
    
    return Array(availableMemos.shuffled().prefix(memoCount))
  }
}

//
//  budgetUseCase.swift
//  Harubee-iOS
//
//  Created by 신승재 on 11/6/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

protocol BudgetUseCase {
  
  func createSalaryBudgetFromOnboarding(
    startDate: Date,
    endDate: Date,
    currentBalance: Int?,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget
  
  /// 새로운 SalaryBudget을 생성합니다.
  /// - Parameters:
  ///   - startDate: SalaryBudget 시작일
  ///   - endDate: SalaryBudget 종료일
  ///   - currentBalance: 온보딩 시 현재 잔액
  ///   - fixedIncome: 고정 수입 금액
  ///   - fixedExpenses: 고정 지출 항목 배열
  /// - Returns: 생성된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.duplicateData`: 동일한 기간의 SalaryBudget이 존재하는 경우
  func createSalaryBudget(
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget
  
  
  /// 모든 SalaryBudget을 가져옵니다.
  /// - Returns: 저장된 모든 SalaryBudget
  func getAllSalaryBudget() throws -> [SalaryBudget]
  
  
  /// 특정 날짜가 포함된 SalaryBudget을 조회합니다.
  /// - Parameter date: 조회할 날짜(nil인 경우 현재 날짜)
  /// - Returns: 해당 날짜가 포함된 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget을 찾을 수 없는 경우
  func getCurrentSalaryBudget(
    date: Date?
  ) throws -> SalaryBudget
  
  
  /// 시작날짜로 시작하는 SalaryBudget을 조회합니다.
  /// - Parameter startDate: 조회할 시작 날짜(nil인 경우 현재 날짜)
  /// - Returns: 해당 날짜로 시작되는 SalaryBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget을 찾을 수 없는 경우
  func getSalaryBudget(
    startDate: Date?
  ) throws -> SalaryBudget
  
  
  /// SalaryBudget의 잔액을 업데이트합니다.
  /// - Parameters:
  ///   - salaryBudget: 업데이트할 SalaryBudget
  ///   - newBalance: 새로운 잔액
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget을 찾을 수 없는 경우
  func updateBalance(
    salaryBudget: SalaryBudget,
    newBalance: Int
  ) throws -> SalaryBudget
  
  
  /// 기본 하루비를 계산하여 SalaryBudget에 반영합니다
  /// - Parameter salaryBudget: 기본 하루비를 다시 계산할 SalaryBudget
  /// - Returns: 변경된 SalaryBudget
  func updateDefaultHarubee(
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
  
  
  /// 고정 수입 금액을 설정합니다.
  /// - Parameters:
  ///   - salaryBudget: 업데이트할 SalaryBudget
  ///   - newIncome: 10000 이상의 금액
  /// - Throws:
  ///   - `DomainError.invalidAmount`: 금액이 10000 미만인 경우
  ///   - `DomainError.dataNotFound`: SalaryBudget이 없는 경우
  func updateFixedIncome(
    salaryBudget: SalaryBudget,
    newIncome: Int
  ) throws -> SalaryBudget
  
  
  /// 모든 지출 항목을 수정합니다.
  /// - Parameters:
  ///   - salaryBudget: 업데이트할 SalaryBudget
  ///   - expenses: 수정할 모든 고정 지출 항목
  /// - Throws:
  ///   - `DomainError.dataNotFound`: SalaryBudget이 없는 경우
  func updateFixedExpenses(
    salaryBudget: SalaryBudget,
    expenses: [TransactionItem]
  ) throws -> SalaryBudget
  
  
  /// 기본 하루비를 계산합니다.
  /// - Parameters:
  ///   - salaryBudget: 조정된 하루비들을 확인하기 위한 SalaryBudget
  ///   - anchorDate: 기본 하루비를 계산할 기준 날짜
  /// - Returns: 계산된 기본 하루비
  func calculateDefaultHarubee(
    salaryBudget: SalaryBudget,
    anchorDate: Date
  ) -> Double
  
  
  /// 평균 하루비를 계산합니다.
  /// - Parameters:
  ///   - endDate: 월급 끝 날짜
  ///   - balance: 잔액
  /// - Returns: 계산된 평균 하루비
  func calculateAverageHarubee(
    endDate: Date, balance: Int
  ) -> Double
  
  
  /// 특정 날짜의 DailyBudget을 조회합니다.
  /// - Parameters:
  ///   - date: 조회할 날짜
  /// - Returns: 해당 날짜의 DailyBudget 객체
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 해당 날짜의 DailyBudget을 찾을 수 없는 경우
  func getDailyBudget(
    date: Date
  ) throws -> DailyBudget
  
  
  /// 특정 날짜의 하루비를 조정합니다.
  /// - Parameters:
  ///   - amount: 조정할 하루비 금액
  ///   - date: 하루비를 조정할 DailyBudget
  ///   - salaryBudget: 기본 하루비를 업데이트할 SalaryBudget
  /// - Returns: 업데이트된 DailyBudget, SalaryBudget
  /// - Throws:
  ///   - `DomainError.dataNotFound`: 조정할 DailyBudget을 찾을 수 없는 경우
  ///   - `DomainError.dateOutOfRange`: 날짜가 예산 기간을 벗어난 경우
  func adjustHarubee(
    amount: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget)
  
  
  /// 지출 및 수입을 기록합니다.
  /// - Parameters:
  ///   - expense: 기록할 지출액
  ///   - income: 기록할 수입액
  ///   - dailyBudget: 지출, 수입을 기록할 DailyBudget
  ///   - salaryBudget: 잔액을 업데이트할 SalaryBudget
  /// - Returns: 업데이트된 DailyBudget, SalaryBudget
  func recordTransaction(
    expense: Int?,
    income: Int?,
    date: Date,
    salaryBudget: SalaryBudget
  ) throws -> (DailyBudget, SalaryBudget)
  
  
  /// 메모 리스트를 업데이트합니다.
  /// - Parameters:
  ///   - memoList: 업데이트할 메모 리스트
  ///   - dailyBudget: 업데이트할 DailyBudget
  /// - Returns: 변경된 DailyBudget
  func updateMemoList(
    memoList: [String],
    dailyBudget: DailyBudget
  ) throws -> DailyBudget
  
  
  /// 고정 수입일을 수정합니다.
  /// - Parameter day: 1-31 사이의 일자
  /// - Throws:
  ///   - `DomainError.dateOutOfRange`: 유효하지 않은 일자인 경우
  func updateIncomeDay(
    day: Int,
    salaryBudget: SalaryBudget
  ) throws -> SalaryBudget
  
  /// 고정 수입일을 저장합니다.
  /// - Parameter day: 1-31 사이의 일자
  func setIncomeDay(day: Int)
  
  /// 저장된 고정 수입일을 조회합니다.
  /// - Returns: 1-31 사이의 고정 수입일
  func getIncomeDay() -> Int?
  
  /// 오늘의 하루비 알림을 보여주는 시간을 설정합니다
  func setTodayHarubeeNotificationTime(time: Date)
  
  /// 저장된 오늘의 하루비 알림 시간을 조회합니다.
  /// - Returns: 0~24시 0~60분
  func getTodayHarubeeNotificationTime() -> Date?
  
  /// 실제 지출을 입력하는 알림을 보여주는 시간을 설정합니다
  func setExpenseNotificationTime(time: Date)
  
  /// 저장된 실제 지출을 입력하는 알림 시간을 조회합니다.
  /// - Returns: 0~24시 0~60분
  func getExpenseNotificationTime() -> Date?
  
  /// 오늘의 하루비 알림 활성화 상태를 설정합니다
  func setTodayHarubeeNotificationStatus(_ isEnabled: Bool)
  
  /// 오늘의 하루비 알림 활성화 상태를 조회합니다
  /// - Returns: 알림 활성화 상태
  func getTodayHarubeeNotificationStatus() -> Bool?
  
  /// 실제 지출 입력 알림 활성화 상태를 설정합니다
  func setExpenseNotificationStatus(_ isEnabled: Bool)
  
  /// 실제 지출 입력 알림 활성화 상태를 조회합니다
  /// - Returns: 알림 활성화 상태
  func getExpenseNotificationStatus() -> Bool?
  
  /// 오늘날짜 이전에 해당하는 DailyBudget에 하루비가 저장되지 않았는지 확인 후 값을 넣어줍니다.
  /// - Parameter salaryBudget: 이번 기간의 SalaryBudget
  /// - Returns: 변경된 SalaryBudget
  func checkSalaryBudget(_ salaryBudget: SalaryBudget) throws -> SalaryBudget
}

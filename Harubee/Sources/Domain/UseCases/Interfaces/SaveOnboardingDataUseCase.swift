//
//  OnboardingUseCase.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

protocol SaveOnboardingDataUseCase {
  
  /// 온보딩에서 입력된 정보들을 저장하는 작업을 실행합니다.
  /// - Parameters:
  ///   - startDate: SalaryBudget 시작일
  ///   - endDate: SalaryBudget 종료일
  ///   - currentBalance: 현재 잔액
  ///   - fixedIncomeDay: 고정 수입일
  ///   - fixedIncomeAmount: 고정 수입 금액
  ///   - fixedExpenses: 고정 지출 항목 배열
  /// - Returns: 생성된 SalaryBudget 객체
  func execute(
    startDate: Date,
    endDate: Date,
    currentBalance: Int,
    fixedIncomeDay: Int,
    fixedIncomeAmount: Int,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget
}

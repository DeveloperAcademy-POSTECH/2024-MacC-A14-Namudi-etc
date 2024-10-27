//
//  DomainError.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

/// 도메인 계층에서 발생할 수 있는 오류들을 정의합니다.
public enum DomainError: Error {
  /// 유효하지 않은 고정 수입일
  case invalidIncomeDay
  /// 유효하지 않은 금액
  case invalidAmount
  /// 중복된 고정 지출 항목
  case duplicateExpense
  /// 존재하지 않는 고정 지출 항목
  case expenseNotFound
  /// 고정 수입 데이터를 찾을 수 없음
  case incomeDataNotFound
}

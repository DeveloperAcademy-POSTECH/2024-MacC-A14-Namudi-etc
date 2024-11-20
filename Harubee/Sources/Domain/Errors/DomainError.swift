//
//  DomainError.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

/// 도메인 계층에서 발생할 수 있는 오류들을 정의합니다.
enum DomainError: LocalizedError {
  case invalidDateRange
  case dateOutOfRange
  case invalidAmount
  case duplicateData
  case dataNotFound
  
  var errorDescription: String? {
    switch self {
    case .invalidDateRange:
      return "시작일이 종료일보다 늦을 수 없습니다"
    case .dateOutOfRange:
      return "선택한 날짜가 예산 기간을 벗어났습니다"
    case .invalidAmount:
      return "금액은 0 이상이어야 합니다"
    case .duplicateData:
      return "이미 존재하는 데이터입니다"
    case .dataNotFound:
      return "데이터를 찾을 수 없습니다"
    }
  }
  
  var failureReason: String? {
    switch self {
    case .invalidDateRange:
      return "예산 기간의 시작일은 종료일보다 이전이어야 합니다"
    case .dateOutOfRange:
      return "선택한 날짜가 현재 설정된 예산 기간에 포함되지 않습니다"
    case .invalidAmount:
      return "금액은 음수가 될 수 없습니다"
    case .duplicateData:
      return "동일한 데이터가 이미 존재합니다"
    case .dataNotFound:
      return "요청한 데이터를 찾을 수 없습니다"
    }
  }
  
  var recoverySuggestion: String? {
    switch self {
    case .invalidDateRange:
      return "시작일과 종료일을 다시 확인해주세요"
    case .dateOutOfRange:
      return "현재 설정된 예산 기간 내의 날짜를 선택해주세요"
    case .invalidAmount:
      return "0 이상의 금액을 입력해주세요"
    case .duplicateData:
      return "기존 데이터를 수정하거나 다른 내용으로 추가해주세요"
    case .dataNotFound:
      return "데이터를 새로고침하고 다시 시도해주세요"
    }
  }
}

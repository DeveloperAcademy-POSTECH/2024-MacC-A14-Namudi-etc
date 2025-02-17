//
//  FixedExpensesRegeneratable.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation


// TODO: 알아두어야 할 사항
// 현재처럼 이전에 저장된 SalaryBudget을 기반으로 새로운 고정 지출 내역을 만드는 것이 아닌,
// 고정 내역을 따로 관리하는 데이터 구조를 구현하게 된다면 해당 프로토콜은 제거 가능
protocol FixedExpensesRegeneratable {
  /// 고정 지출 내역을 시작, 종료 날짜에 맞춰 재생성합니다
  /// - Parameters:
  ///   - startDate: 시작 날짜
  ///   - endDate: 종료 날짜
  ///   - fixedExpenses: 이전 고정 지출 내역
  /// - Returns: 새로운 고정 지출 내역
  func regenerateFixedExpenses(
    startDate: Date,
    endDate: Date,
    from fixedExpenses: [TransactionItem]
  ) -> [TransactionItem]
}

extension FixedExpensesRegeneratable {
  func regenerateFixedExpenses(
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
}

//
//  DefaultHarubeeCalculatable.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

protocol DefaultHarubeeCalculatable {
  func calculateDefaultHarubee(
    salaryBudget: SalaryBudget,
    anchorDate: Date
  ) -> Double
}

// 기본 메서드 구현
extension DefaultHarubeeCalculatable {
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
}

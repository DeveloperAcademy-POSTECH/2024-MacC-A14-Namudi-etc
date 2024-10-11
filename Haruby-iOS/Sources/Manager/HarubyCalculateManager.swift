//
//  HarubyCalculateManager.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

final class HarubyCalculateManager {
    // 평균하루비를 구하는 메서드
    func getAverageHarubyFromNow(endDate: Date, balance: Int) -> Int {
        // 1. 현재로부터 endDate까지 남은 일자 구하기 (+1)
        let now = Date().formattedDate
        let remain = endDate.timeIntervalSince(now) / 86400 + 1
        // 2. 1에서 나온 값으로 balance를 나눈 후 리턴
        return balance / Int(remain)
    }
    
    // 잔액 반영후에 이 메서드 사용하기
    func getDefaultHarubyFromNow(salaryBudget: SalaryBudget) -> Int {
        // 1. nil count 변수 생성 (var nilCount = 0)
        var nilCount = 0
        var newBalance = salaryBudget.balance
        let now = Date().formattedDate
        
        // 2. 현재 날짜로부터 endDate까지 DailyBudget을 순차적으로 방문
        for dailyBudget in salaryBudget.dailyBudgets {
            if dailyBudget.date > now { continue }
            
            // 2.1. if 방문 날짜의 haruby가 nil인 경우: nil += 1
            //      else balance - 방문 날짜의 하루비
            if let haruby = dailyBudget.haruby { newBalance -= haruby }
            else { nilCount += 1 }
        }
        
        return nilCount == 0 ? newBalance : newBalance / nilCount
    }
}

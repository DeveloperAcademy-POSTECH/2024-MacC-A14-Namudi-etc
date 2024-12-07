//
//  HarubeeTests.swift
//  HarubeeTests
//
//  Created by 이정동 on 12/7/24.
//

import Testing
import Foundation
@testable import Harubee

struct SalaryBudgetPeriodTests {
  
  @Test(arguments: testObjects)
  func checkPeriod(object: TestObject) async throws {
    
    let result = calculateStartAndEndDateForTest(
      from: object.incomeDay,
      current: object.currentDate
    )
    let expectedStart = object.expectedStart
    let expectedEnd = object.expectedEnd
    
    #expect(result.0 == expectedStart)
    #expect(result.1 == expectedEnd)
  }
}


struct TestObject {
  var incomeDay: Int
  var currentDate: Date
  var expectedStart: Date
  var expectedEnd: Date
}

let testObjects: [TestObject] = createTestObjects()


func calculateStartAndEndDateForTest(
  from incomeDay: Int,
  current: Date
) -> (Date, Date) {
  let calendar = Calendar.current
  let today = current
  
  var incomeStartDate: Date {
    
    let todayComponents = calendar.dateComponents(
      [.year, .month, .day], from: today
    )
    let currentMonthLastDay = calendar.range(
      of: .day, in: .month, for: today
    )!.upperBound - 1
    
    
    if incomeDay > currentMonthLastDay {
      return Date.create(
        year: todayComponents.year!,
        month: todayComponents.month!,
        day: currentMonthLastDay
      )
      
    } else if incomeDay <= todayComponents.day! {
      return Date.create(
        year: todayComponents.year!,
        month: todayComponents.month!,
        day: incomeDay
      )
    } else {
      let previousMonthFromToday = calendar.date(
        byAdding: .month, value: -1, to: today
      )!
      let previousMonthComponents = calendar.dateComponents(
        [.year, .month, .day], from: previousMonthFromToday
      )
      
      return Date.create(
        year: previousMonthComponents.year!,
        month: previousMonthComponents.month!,
        day: incomeDay
      )
    }
  }
  
  var incomeEndDate: Date {
    let nextMonthFromStartDate = calendar.date(
      byAdding: .month,
      value: 1,
      to: incomeStartDate
    )!
    let nextMonthComponents = calendar.dateComponents(
      [.year, .month, .day], from: nextMonthFromStartDate
    )
    let nextMonthLastDay = calendar.range(
      of: .day, in: .month, for: nextMonthFromStartDate
    )!.upperBound - 1
    let endDay = min(incomeDay, nextMonthLastDay)
    
    return Date.create(
      year: nextMonthComponents.year!,
      month: nextMonthComponents.month!,
      day: endDay
    ).addingTimeInterval(-86400)
  }
  
  return (incomeStartDate, incomeEndDate)
}

func createTestObjects() -> [TestObject] {
  return [
    // MARK: - Case 1. 현재 2024년 2월 29일
    
    // 1. 수입일이 31일로 설정되있는 경우 -> 시작: 2024년 2월 29일, 종료: 2024년 3월 30일
    TestObject(
      incomeDay: 31,
      currentDate: Date.create(year: 2024, month: 2, day: 29),
      expectedStart: Date.create(year: 2024, month: 2, day: 29),
      expectedEnd: Date.create(year: 2024, month: 3, day: 30)
    ),
    
    // 2. 수입일이 30일로 설정되있는 경우 -> 시작: 2024년 2월 29일, 종료: 2024년 3월 29일
    TestObject(
      incomeDay: 30,
      currentDate: Date.create(year: 2024, month: 2, day: 29),
      expectedStart: Date.create(year: 2024, month: 2, day: 29),
      expectedEnd: Date.create(year: 2024, month: 3, day: 29)
    ),
    
    // 3. 수입일이 15일로 설정되있는 경우 -> 시작: 2024년 2월 15일, 종료: 2024년 3월 14일
    TestObject(
      incomeDay: 15,
      currentDate: Date.create(year: 2024, month: 2, day: 29),
      expectedStart: Date.create(year: 2024, month: 2, day: 15),
      expectedEnd: Date.create(year: 2024, month: 3, day: 14)
    ),
    
    
    // MARK: - Case 2. 현재 2024년 4월 30일
    
    // 1. 수입일이 31일로 설정되있는 경우 -> 시작: 2024년 4월 30일, 종료: 2024년 5월 30일
    TestObject(
      incomeDay: 31,
      currentDate: Date.create(year: 2024, month: 4, day: 30),
      expectedStart: Date.create(year: 2024, month: 4, day: 30),
      expectedEnd: Date.create(year: 2024, month: 5, day: 30)
    ),
    
    // 2. 수입일이 30일로 설정되있는 경우 -> 시작: 2024년 4월 30일, 종료: 2024년 5월 29일
    TestObject(
      incomeDay: 30,
      currentDate: Date.create(year: 2024, month: 4, day: 30),
      expectedStart: Date.create(year: 2024, month: 4, day: 30),
      expectedEnd: Date.create(year: 2024, month: 5, day: 29)
    ),
    
    // 3. 수입일이 15일로 설정되있는 경우 -> 시작: 2024년 4월 15일, 종료: 2024년 5월 14일
    TestObject(
      incomeDay: 15,
      currentDate: Date.create(year: 2024, month: 4, day: 30),
      expectedStart: Date.create(year: 2024, month: 4, day: 15),
      expectedEnd: Date.create(year: 2024, month: 5, day: 14)
    ),
    
    
    // MARK: - Case 3. 현재 2024년 5월 31일
    
    // 1. 수입일이 31일로 설정되있는 경우 -> 시작: 2024년 4월 30일, 종료: 2024년 5월 30일
    TestObject(
      incomeDay: 31,
      currentDate: Date.create(year: 2024, month: 5, day: 31),
      expectedStart: Date.create(year: 2024, month: 5, day: 31),
      expectedEnd: Date.create(year: 2024, month: 6, day: 29)
    ),
    
    // 2. 수입일이 30일로 설정되있는 경우 -> 시작: 2024년 4월 30일, 종료: 2024년 5월 29일
    TestObject(
      incomeDay: 30,
      currentDate: Date.create(year: 2024, month: 5, day: 31),
      expectedStart: Date.create(year: 2024, month: 5, day: 30),
      expectedEnd: Date.create(year: 2024, month: 6, day: 29)
    ),
    
    // 3. 수입일이 15일로 설정되있는 경우 -> 시작: 2024년 4월 15일, 종료: 2024년 5월 14일
    TestObject(
      incomeDay: 15,
      currentDate: Date.create(year: 2024, month: 5, day: 31),
      expectedStart: Date.create(year: 2024, month: 5, day: 15),
      expectedEnd: Date.create(year: 2024, month: 6, day: 14)
    ),
    
    
    // MARK: - Case 4. 현재 2024년 3월 1일
    
    // 1. 수입일이 31일로 설정되있는 경우 -> 시작: 2024년 2월 29일, 종료: 2024년 3월 30일
    TestObject(
      incomeDay: 31,
      currentDate: Date.create(year: 2024, month: 3, day: 1),
      expectedStart: Date.create(year: 2024, month: 2, day: 29),
      expectedEnd: Date.create(year: 2024, month: 3, day: 30)
    ),
    
    // 2. 수입일이 30일로 설정되있는 경우 -> 시작: 2024년 2월 29일, 종료: 2024년 3월 29일
    TestObject(
      incomeDay: 30,
      currentDate: Date.create(year: 2024, month: 3, day: 1),
      expectedStart: Date.create(year: 2024, month: 2, day: 29),
      expectedEnd: Date.create(year: 2024, month: 3, day: 29)
    ),
    
    // 3. 수입일이 1일로 설정되있는 경우 -> 시작: 2024년 3월 1일, 종료: 2024년 3월 31일
    TestObject(
      incomeDay: 1,
      currentDate: Date.create(year: 2024, month: 3, day: 1),
      expectedStart: Date.create(year: 2024, month: 3, day: 1),
      expectedEnd: Date.create(year: 2024, month: 3, day: 31)
    ),
  ]
}


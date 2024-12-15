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
      anchor: object.currentDate
    )
    let expectedStart = object.expectedStart
    let expectedEnd = object.expectedEnd
    
    #expect(result.0 == expectedStart)
    #expect(result.1 == expectedEnd)
  }
  
  @Test(arguments: testObjects)
  func checkStartDate(object: TestObject) async throws {
    let startDate = calculateStartDate(
      from: object.incomeDay,
      anchor: object.currentDate
    )
    let expectedStart = object.expectedStart
    
    #expect(startDate == expectedStart)
  }
  
  @Test(arguments: testObjects)
  func checkEndDate(object: TestObject) async throws {
    let endDate = calculateEndDate(
      from: object.incomeDay,
      anchor: object.currentDate
    )
    let expectedEnd = object.expectedEnd
    
    #expect(endDate == expectedEnd)
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
  anchor date: Date
) -> (Date, Date) {
  
  let incomeStartDate = calculateStartDate(from: incomeDay, anchor: date)
  let incomeEndDate = calculateEndDate(from: incomeDay, anchor: date)
  
  return (incomeStartDate, incomeEndDate)
}

func calculateStartDate(
  from incomeDay: Int,
  anchor date: Date
) -> Date {
  let date = date.formattedDate
  let dateComponents = date.getDateComponents([.year, .month, .day])
  let lastDayOfMonth = date.lastDayOfMonth
  
  // 전달이 시작 날짜인 경우
  // -> 수입일 <= 기준 날짜의 Day || 기준 날짜의 Day가 마지막 날
  if incomeDay <= dateComponents.day!
      || lastDayOfMonth == dateComponents.day! {
    
    return Date.create(
      year: dateComponents.year!,
      month: dateComponents.month!,
      day: min(incomeDay, lastDayOfMonth)
    )
    
  // 이번달이 시작 날짜인 경우
  // -> 수입일 > 기준 날짜의 Day && 기준 날짜의 Day가 마지막 날이 아님
  } else {
    
    let year = dateComponents.year!
    let month = dateComponents.month!
    let previousDate = Date.create(
      year: month == 1 ? year - 1 : year,
      month: month == 1 ? 12 : month - 1,
      day: 1
    )
    
    let previousComponents = previousDate.getDateComponents([.year, .month, .day])
    let previousLastDayOfMonth = previousDate.lastDayOfMonth
    
    return Date.create(
      year: previousComponents.year!,
      month: previousComponents.month!,
      day: min(previousLastDayOfMonth, incomeDay)
    )
  }
}

func calculateEndDate(
  from incomeDay: Int,
  anchor date: Date
) -> Date {
  let date = date.formattedDate
  let dateComponents = date.getDateComponents([.year, .month, .day])
  let lastDayOfMonth = date.lastDayOfMonth
  
  // 이번달이 종료 날짜인 경우
  // -> 기준 날짜의 Day < 수입일 && 기준 날짜의 Day가 마지막 날이 아님
  if dateComponents.day! < incomeDay
      && dateComponents.day! != lastDayOfMonth {
    
    return Date.create(
      year: dateComponents.year!,
      month: dateComponents.month!,
      day: min(lastDayOfMonth, incomeDay) - 1
    )
    
  // 다음달이 종료 날짜인 경우
  // 기준 날짜의 Day >= 수입일 || 기준 날짜의 Day가 마지막 날
  } else {
    
    let year = dateComponents.year!
    let month = dateComponents.month!
    
    let nextDate = Date.create(
      year: month == 12 ? year + 1 : year,
      month: month == 12 ? 1 : month + 1,
      day: 1
    )
    
    let nextDateComponents = nextDate.getDateComponents([.year, .month, .day])
    let nextLastDayOfMonth = nextDate.lastDayOfMonth
    
    return Date.create(
      year: nextDateComponents.year!,
      month: nextDateComponents.month!,
      day: min(nextLastDayOfMonth, incomeDay) - 1
    )
  }
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
    
    // 4. 수입일이 1일로 설정되있는 경우 -> 시작: 2024년 4월 1일, 종료: 2024년 4월 30일
    TestObject(
      incomeDay: 1,
      currentDate: Date.create(year: 2024, month: 4, day: 30),
      expectedStart: Date.create(year: 2024, month: 4, day: 1),
      expectedEnd: Date.create(year: 2024, month: 4, day: 30)
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
    
    
    // MARK: - Case 5. 현재 2024년 1월 1일
    
    // 1. 수입일이 31일로 설정되있는 경우 -> 시작: 2023년 12월 31일, 종료: 2024년 1월 30일
    TestObject(
      incomeDay: 31,
      currentDate: Date.create(year: 2024, month: 1, day: 1),
      expectedStart: Date.create(year: 2023, month: 12, day: 31),
      expectedEnd: Date.create(year: 2024, month: 1, day: 30)
    ),
    
    
    // MARK: - Case 6. 현재 2024년 12월 31일
    
    // 1. 수입일이 31일로 설정되있는 경우 -> 시작: 2024년 12월 31일, 종료: 2025년 1월 30일
    TestObject(
      incomeDay: 31,
      currentDate: Date.create(year: 2024, month: 12, day: 31),
      expectedStart: Date.create(year: 2024, month: 12, day: 31),
      expectedEnd: Date.create(year: 2025, month: 1, day: 30)
    ),
    
    // 2. 수입일이 30일로 설정되있는 경우 -> 시작: 2023년 12월 30일, 종료: 2024년 1월 29일
    TestObject(
      incomeDay: 30,
      currentDate: Date.create(year: 2024, month: 12, day: 31),
      expectedStart: Date.create(year: 2024, month: 12, day: 30),
      expectedEnd: Date.create(year: 2025, month: 1, day: 29)
    ),
  ]
}


//
//  UserDefaultsRepository.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

protocol UserDefaultsRepository {
  
  /// UserDefaults에 월급일을 저장합니다.
  /// - Parameter day: 저장할 월급일(1-31)
  func saveIncomeDay(_ day: Int)
  
  /// UserDefaults에서 월급일을 읽어옵니다.
  /// - Returns: 저장된 월급일. 저장된 값이 없으면 nil
  func readIncomeDay() -> Int?
  
  /// UserDefaults에서 오늘의 하루비 알림시간을 저장합니다.
  func saveTodayHarubeeNotificationTime(_ time: Date)
  
  /// UserDefaults에서 오늘의 하루비 알림시간을 읽어옵니다.
  /// - Returns: 저장된 시간. 없으면 nil
  func readTodayHarubeeNotificationTime() -> Date?
  
  /// UserDefaults에서 실제 지출 입력 알림시간을 저장합니다.
  func saveExpenseNotificationTime(_ time: Date)
  
  /// UserDefaults에서 실제 지출 입력 알림시간을 읽어옵니다.
  /// - Returns: 저장된 시간. 없으면 nil
  func readExpenseNotificationTime() -> Date?
  
  /// UserDefaults에서 오늘의 하루비 알림 활성 상태를 저장합니다.
  /// - Parameter isEnabled: 활성화 상태
  func saveTodayHarubeeNotificationStatus(_ isEnabled: Bool)
  
  /// UserDefaults에서 오늘의 하루비 알림 활성 상태를 읽어옵니다.
  /// - Returns: 저장된 활성화 상태. 없으면 기본값 true
  func readTodayHarubeeNotificationStatus() -> Bool?
  
  /// UserDefaults에서 실제 지출 입력 알림 활성 상태를 저장합니다.
  /// - Parameter isEnabled: 활성화 상태
  func saveExpenseNotificationStatus(_ isEnabled: Bool)
  
  /// UserDefaults에서 실제 지출 입력 알림 활성 상태를 읽어옵니다.
  /// - Returns: 저장된 활성화 상태. 없으면 기본값 true
  func readExpenseNotificationStatus() -> Bool?
  
  /// UserDefaults에 마지막 접속 날짜를 저장합니다.
  /// - Parameter day: 현재 날짜
  func saveLastAccessDate(_ date: Date)
  
  /// UserDefaults에서 마지막 접속 날짜를 가져옵니다
  /// - Returns: 마지막 접속 날짜
  func readLastAccessDate() -> Date?
}

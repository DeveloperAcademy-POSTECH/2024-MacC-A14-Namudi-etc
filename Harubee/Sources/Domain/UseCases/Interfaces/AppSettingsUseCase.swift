//
//  AppSettingsUseCase.swift
//  Harubee
//
//  Created by 이정동 on 1/9/25.
//

import Foundation

protocol AppSettingsUseCase {
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
}

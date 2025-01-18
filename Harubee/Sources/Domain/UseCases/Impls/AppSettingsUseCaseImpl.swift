//
//  AppSettingsUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 1/9/25.
//

import Foundation

final class AppSettingsUseCaseImpl: AppSettingsUseCase {
  
  private let userDefaultsRepository: UserDefaultsRepository
  
  private let calendar: Calendar = .current
  
  init(
    userDefaultsRepository: UserDefaultsRepository
  ) {
    self.userDefaultsRepository = userDefaultsRepository
  }
  
  func setTodayHarubeeNotificationTime(time: Date) {
    userDefaultsRepository.saveTodayHarubeeNotificationTime(time)
  }

  func getTodayHarubeeNotificationTime() -> Date? {
    // 지정된 알림 시간을 가져오고 저장된 알림 시간이 없으면 9:00 AM으로 설정하기
    guard let time = userDefaultsRepository.readTodayHarubeeNotificationTime()
    else {
      let today = Date()
      var dateComponents = calendar.dateComponents(
        [.year, .month, .day], from: today
      )
      dateComponents.hour = 9
      dateComponents.minute = 0
      dateComponents.timeZone = TimeZone.current
      
      let defaultDate = calendar.date(from: dateComponents)
      userDefaultsRepository.saveTodayHarubeeNotificationTime(defaultDate!)
      
      return defaultDate
    }
    
    return time
  }

  func setExpenseNotificationTime(time: Date) {
    userDefaultsRepository.saveExpenseNotificationTime(time)
  }

  func getExpenseNotificationTime() -> Date? {
    // 지정된 알림 시간을 가져오고 저장된 알림 시간이 없으면 10:00 PM으로 설정하기
    guard let time = userDefaultsRepository.readExpenseNotificationTime()
    else {
      let today = Date()
      var dateComponents = calendar.dateComponents(
        [.year, .month, .day], from: today
      )
      dateComponents.hour = 22
      dateComponents.minute = 0
      dateComponents.timeZone = TimeZone.current
      
      let defaultDate = calendar.date(from: dateComponents)
      userDefaultsRepository.saveExpenseNotificationTime(defaultDate!)
      
      return defaultDate
    }
    
    return time
  }
  
  func setTodayHarubeeNotificationStatus(_ isEnabled: Bool) {
    userDefaultsRepository.saveTodayHarubeeNotificationStatus(isEnabled)
  }

  func getTodayHarubeeNotificationStatus() -> Bool? {
    guard let status = userDefaultsRepository.readTodayHarubeeNotificationStatus()
    else {
      userDefaultsRepository.saveTodayHarubeeNotificationStatus(false)
      return false
    }
    return status
  }

  func setExpenseNotificationStatus(_ isEnabled: Bool) {
    userDefaultsRepository.saveExpenseNotificationStatus(isEnabled)
  }

  func getExpenseNotificationStatus() -> Bool? {
    guard let status = userDefaultsRepository.readExpenseNotificationStatus()
    else {
      userDefaultsRepository.saveTodayHarubeeNotificationStatus(false)
      return false
    }
    return status
  }
}

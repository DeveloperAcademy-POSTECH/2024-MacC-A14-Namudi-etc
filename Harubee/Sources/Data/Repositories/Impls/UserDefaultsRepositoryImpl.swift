//
//  UserDefaultsRepositoryImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

final class UserDefaultsRepositoryImpl: UserDefaultsRepository {

  private enum Keys {
    static let incomeDay = "income_day"
    static let harubeeNotificationTime = "harubee_notification_time"
    static let expenseNotificationTime = "expense_notification_time"
  }
  
  private let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  func saveIncomeDay(_ day: Int) throws {
    userDefaults.set(day, forKey: Keys.incomeDay)
  }
  
  func readIncomeDay() -> Int? {
    userDefaults.object(forKey: Keys.incomeDay) as? Int
  }
  
  func saveTodayHarubeeNotificationTime(_ time: Date) throws {
    userDefaults.set(time, forKey: Keys.harubeeNotificationTime)
  }

  func readTodayHarubeeNotificationTime() -> Date? {
    userDefaults.object(forKey: Keys.harubeeNotificationTime) as? Date
  }

  func saveExpenseNotificationTime(_ time: Date) throws {
    userDefaults.set(time, forKey: Keys.expenseNotificationTime)
  }

  func readExpenseNotificationTime() -> Date? {
    userDefaults.object(forKey: Keys.expenseNotificationTime) as? Date
  }
}

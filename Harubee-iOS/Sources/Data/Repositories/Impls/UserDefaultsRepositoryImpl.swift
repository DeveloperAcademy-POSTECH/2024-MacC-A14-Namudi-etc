//
//  UserDefaultsRepositoryImpl.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
  private enum Keys {
    static let incomeDay = "income_day"
  }
  
  private let userDefaults: UserDefaults
  
  public init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  public func saveIncomeDay(_ day: Int) throws {
    userDefaults.set(day, forKey: Keys.incomeDay)
  }
  
  public func readIncomeDay() -> Int? {
    userDefaults.object(forKey: Keys.incomeDay) as? Int
  }
}

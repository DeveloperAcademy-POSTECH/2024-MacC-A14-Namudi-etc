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
  func saveIncomeDay(_ day: Int) throws
  
  /// UserDefaults에서 월급일을 읽어옵니다.
  /// - Returns: 저장된 월급일. 저장된 값이 없으면 nil
  func readIncomeDay() -> Int?
}

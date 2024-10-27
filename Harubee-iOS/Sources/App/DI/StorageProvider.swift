//
//  StorageProvider.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Data
import SwiftData

final class StorageProvider {
  lazy var modelContainer: ModelContainer = {
    let schema = Schema([
      /*
       TODO: DTO 설정 후 주석 해제 필요
       BudgetDTO.self,
       DailyBudgetDTO.self,
       TransactionItemDTO.self
       */
    ])
    
    do {
      return try ModelContainer(for: schema)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }()
  
  // UserDefaults 설정
  lazy var userDefaults: UserDefaults = {
    return UserDefaults.standard
  }()
}

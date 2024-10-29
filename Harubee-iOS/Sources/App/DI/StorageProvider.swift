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
      SalaryBudgetDTO.self,
      DailyBudgetDTO.self,
      TransactionItemDTO.self
    ])
    
    let configuration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false
    )
    
    do {
      let container = try ModelContainer(
        for: schema,
        configurations: configuration
      )
      return container
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }()
  
  lazy var modelContext: ModelContext = {
    ModelContext(self.modelContainer)
  }()
  
  // UserDefaults 설정
  lazy var userDefaults: UserDefaults = {
    return UserDefaults.standard
  }()
}

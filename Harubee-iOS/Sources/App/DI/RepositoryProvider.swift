//
//  RepositoryProvider.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import Data

final class RepositoryProvider {
  private let storageProvider: StorageProvider
  
  init(storageProvider: StorageProvider) {
    self.storageProvider = storageProvider
  }
  
  lazy var budgetRepository: BudgetRepository = {
    BudgetRepositoryImpl(
      modelContainer: storageProvider.modelContainer
    )
  }()
  
  lazy var settingsRepository: SettingsRepository = {
    SettingsRepositoryImpl(
      userDefaults: storageProvider.userDefaults
    )
  }()
}

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
  
  lazy var salaryBudgetRepository: SalaryBudgetRepository = {
    SalaryBudgetRepositoryImpl(
      modelContext: storageProvider.modelContext
    )
  }()
  
  lazy var dailyBudgetRepository: DailyBudgetRepository = {
    DailyBudgetRepositoryImpl(
      modelContext: storageProvider.modelContext
    )
  }()
  
  // TODO: - UserDefalts 관련 Repository 혹은 Manager 추가 필요
}

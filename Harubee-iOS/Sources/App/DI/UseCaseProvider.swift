//
//  UseCaseProvider.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

final class UseCaseProvider {
  private let repositoryProvider: RepositoryProvider
  
  init(repositoryProvider: RepositoryProvider) {
    self.repositoryProvider = repositoryProvider
  }
  
  lazy var budgetCalculationUseCase: BudgetCalculationUseCase = {
    BudgetCalculationUseCaseImpl(
      budgetRepository: repositoryProvider.budgetRepository
    )
  }()
  
  lazy var budgetPeriodUseCase: SalaryBudgetUseCase = {
    SalaryBudgetUseCaseImpl(
      budgetRepository: repositoryProvider.budgetRepository,
      calculationUseCase: budgetCalculationUseCase
    )
  }()
  
  lazy var dailyBudgetUseCase: DailyBudgetUseCase = {
    DailyBudgetUseCaseImpl(
      budgetRepository: repositoryProvider.budgetRepository,
      calculationUseCase: budgetCalculationUseCase
    )
  }()
  
  lazy var settingsUseCase: SettingsUseCase = {
    SettingsUseCaseImpl(
      settingsRepository: repositoryProvider.settingsRepository
    )
  }()
}

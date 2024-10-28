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
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository
    )
  }()
  
  lazy var budgetPeriodUseCase: SalaryBudgetUseCase = {
    SalaryBudgetUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      calculationUseCase: budgetCalculationUseCase
    )
  }()
  
  lazy var dailyBudgetUseCase: DailyBudgetUseCase = {
    DailyBudgetUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      dailyBudgetRepository: repositoryProvider.dailyBudgetRepository,
      calculationUseCase: budgetCalculationUseCase
    )
  }()
  
  lazy var settingsUseCase: SettingsUseCase = {
    SettingsUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository
    )
  }()
}

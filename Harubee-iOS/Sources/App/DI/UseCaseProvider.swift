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
  
  lazy var calculateUseCase: CalculateUseCase = {
    CalculateUseCaseImpl(
    )
  }()
  
  lazy var salaryBudgetUseCase: SalaryBudgetUseCase = {
    SalaryBudgetUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      calculateUseCase: calculateUseCase
    )
  }()
  
  lazy var dailyBudgetUseCase: DailyBudgetUseCase = {
    DailyBudgetUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      dailyBudgetRepository: repositoryProvider.dailyBudgetRepository,
      calculateUseCase: calculateUseCase
      
    )
  }()
  
  lazy var settingsUseCase: SettingsUseCase = {
    SettingsUseCaseImpl(
      userDefaultsRepository: repositoryProvider.userDefaltsRepository,
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      salaryBudgetUseCase: salaryBudgetUseCase,
      calculateUseCase: calculateUseCase
    )
  }()
}

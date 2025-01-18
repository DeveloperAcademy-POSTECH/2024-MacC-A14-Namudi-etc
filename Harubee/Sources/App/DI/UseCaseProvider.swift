//
//  UseCaseProvider.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

final class UseCaseProvider {
  private let repositoryProvider: RepositoryProvider
  private let serviceProvider: ServiceProvider
  
  init(
    repositoryProvider: RepositoryProvider,
    serviceProvider: ServiceProvider
  ) {
    self.repositoryProvider = repositoryProvider
    self.serviceProvider = serviceProvider
  }
  
  lazy var budgetUseCase: BudgetUseCase = {
    BudgetUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      dailyBudgetRepository: repositoryProvider.dailyBudgetRepository,
      userDefaultsRepository: repositoryProvider.userDefaltsRepository
    )
  }()
  
  lazy var appSettingsUseCase: AppSettingsUseCase = {
    AppSettingsUseCaseImpl(
      userDefaultsRepository: repositoryProvider.userDefaltsRepository
    )
  }()
  
  lazy var analyticsUseCase: AnalyticsUseCase = {
    AnalyticsUseCaseImpl(analyticsService: serviceProvider.analyticsService)
  }()
}

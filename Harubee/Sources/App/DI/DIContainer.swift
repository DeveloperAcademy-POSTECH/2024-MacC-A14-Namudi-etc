//
//  DIContainer.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

final class DIContainer {
  static let shared = DIContainer()
  
  private let storageProvider: StorageProvider
  private let repositoryProvider: RepositoryProvider
  private let serviceProvider: ServiceProvider
  private let useCaseProvider: UseCaseProvider
  
  private init() {
    self.storageProvider = StorageProvider()
    self.repositoryProvider = RepositoryProvider(
      storageProvider: storageProvider
    )
    self.serviceProvider = ServiceProvider()
    self.useCaseProvider = UseCaseProvider(
      repositoryProvider: repositoryProvider,
      serviceProvider: serviceProvider
    )
  }
  
  // MARK: - ViewModels
  func makeTodayViewModel() -> TodayViewModel {
    TodayViewModel(
      budgetUseCase: useCaseProvider.budgetUseCase
    )
  }
  
  func makeOnboardingViewModel() -> OnboardingViewModel {
    OnboardingViewModel(
      budgetUseCase: useCaseProvider.budgetUseCase
    )
  }
  
  func makeCalendarViewModel() -> CalendarViewModel {
    CalendarViewModel(
      budgetUseCase: useCaseProvider.budgetUseCase
    )
  }
  
  func makeHarubeeAdjustViewModel(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) -> HarubeeAdjustViewModel {
    HarubeeAdjustViewModel(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget,
      budgetUseCase: useCaseProvider.budgetUseCase,
      analyticsUseCase: useCaseProvider.analyticsUseCase
    )
  }
  
  func makeBalanceAdjustViewModel(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) -> BalanceAdjustViewModel {
    BalanceAdjustViewModel(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget,
      budgetUseCase: useCaseProvider.budgetUseCase
    )
  }
  
  func makeTransactionInputViewModel(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) -> TransactionInputViewModel {
    TransactionInputViewModel(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget,
      budgetUseCase: useCaseProvider.budgetUseCase,
      analyticsUseCase: useCaseProvider.analyticsUseCase
    )
  }

  func makeSettingViewModel(salaryBudget: SalaryBudget) -> SettingViewModel {
    SettingViewModel(
      budgetUseCase: useCaseProvider.budgetUseCase,
      appSettingsUseCase: useCaseProvider.appSettingsUseCase,
      analyticsUseCase: useCaseProvider.analyticsUseCase,
      salaryBudget: salaryBudget
    )
  }
}

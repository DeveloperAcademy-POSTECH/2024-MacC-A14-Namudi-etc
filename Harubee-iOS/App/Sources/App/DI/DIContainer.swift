//
//  DIContainer.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

final class DIContainer {
  static let shared = DIContainer()
  
  private let storageProvider: StorageProvider
  private let repositoryProvider: RepositoryProvider
  private let useCaseProvider: UseCaseProvider
  
  private init() {
    self.storageProvider = StorageProvider()
    self.repositoryProvider = RepositoryProvider(
      storageProvider: storageProvider
    )
    self.useCaseProvider = UseCaseProvider(
      repositoryProvider: repositoryProvider
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
      salaryBudgetUseCase: useCaseProvider.salaryBudgetUseCase
    )
  }
  
  func makeCalendarViewModel() -> CalendarViewModel {
    CalendarViewModel(
      salaryBudgetUseCase: useCaseProvider.salaryBudgetUseCase,
      dailyBudgetUseCase: useCaseProvider.dailyBudgetUseCase
    )
  }
  
  func makeHarubeeAdjustViewModel(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) -> HarubeeAdjustViewModel {
    HarubeeAdjustViewModel(
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
      budgetUseCase: useCaseProvider.budgetUseCase
    )
  }

  func makeSettingViewModel(salaryBudget: SalaryBudget) -> SettingViewModel {
    SettingViewModel(
      budgetUseCase: useCaseProvider.budgetUseCase,
      salaryBudget: salaryBudget
    )
  }
}

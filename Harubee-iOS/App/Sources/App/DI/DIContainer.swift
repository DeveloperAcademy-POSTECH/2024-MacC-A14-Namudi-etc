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
      budgetUseCase: useCaseProvider.BudgetUseCase
    )
  }
  
  func makeOnboardingViewModel() -> OnboardingViewModel {
    OnboardingViewModel(
      salaryBudgetUseCase: useCaseProvider.salaryBudgetUseCase
    )
  }
  
  func makeCalendarViewModel() -> CalendarViewModel {
    CalendarViewModel(
      salaryBudgetUseCase: useCaseProvider.salaryBudgetUseCase
    )
  }
}

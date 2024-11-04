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
  
  /*
   TODO: 추후 구현 필요
  func makeTodayViewModel() -> TodayViewModel {
    TodayViewModel(
      calculationUseCase: useCaseProvider.budgetCalculationUseCase,
      salaryBudgetUseCase: useCaseProvider.salaryBudgetUseCase,
      dailyBudgetUseCase: useCaseProvider.dailyBudgetUseCase
    )
  }
   
   ...
   */
  
  
  // TODO: 추후 구현 수정 필요
  func makeCalendarViewModel() -> CalendarViewModel {
    CalendarViewModel(
      salaryBudgetUseCase: useCaseProvider.salaryBudgetUseCase
    )
  }
}

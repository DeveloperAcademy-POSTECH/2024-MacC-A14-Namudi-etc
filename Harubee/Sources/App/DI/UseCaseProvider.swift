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
  
  init(repositoryProvider: RepositoryProvider) {
    self.repositoryProvider = repositoryProvider
  }
  
  lazy var budgetUseCase: BudgetUseCase = {
    BudgetUseCaseImpl(
      salaryBudgetRepository: repositoryProvider.salaryBudgetRepository,
      dailyBudgetRepository: repositoryProvider.dailyBudgetRepository,
      userDefaultsRepository: repositoryProvider.userDefaltsRepository
    )
  }()
}

//
//  ManageMemoUseCaseImpl.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

final class ManageMemoListUseCaseImpl: ManageMemoListUseCase {
  
  private let dailyBudgetRepository: DailyBudgetRepository
  
  init(dailyBudgetRepository: DailyBudgetRepository) {
    self.dailyBudgetRepository = dailyBudgetRepository
  }
  
  func updateMemoList(
    memoList: [String],
    dailyBudget: DailyBudget
  ) throws -> DailyBudget {
    
    return try dailyBudgetRepository.updateMemo(
      dailyBudget.id,
      memo: memoList
    )
  }
}

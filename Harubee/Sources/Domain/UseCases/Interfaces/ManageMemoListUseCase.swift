//
//  ManageMemoUseCase.swift
//  Harubee
//
//  Created by 이정동 on 2/17/25.
//

import Foundation

protocol ManageMemoListUseCase {
  /// 메모 리스트를 업데이트합니다.
  /// - Parameters:
  ///   - memoList: 업데이트할 메모 리스트
  ///   - dailyBudget: 업데이트할 DailyBudget
  /// - Returns: 변경된 DailyBudget
  func updateMemoList(
    memoList: [String],
    dailyBudget: DailyBudget
  ) throws -> DailyBudget
}

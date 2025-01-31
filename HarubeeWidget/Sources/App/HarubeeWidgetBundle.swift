//
//  HarubeeWidgetBundle.swift
//  HarubeeWidget
//
//  Created by 이정동 on 11/20/24.
//

import WidgetKit
import SwiftUI

@main
struct HarubeeWidgetBundle: WidgetBundle {
  var body: some Widget {
    HarubeeWidget()
  }
}


/*
 Harubee App Target 파일들 중 Widget Target을 추가한 파일 리스트
 
 Resources
  - Colors
  - Images
  > Fonts
    - semiBold
    - medium
 Sources
  > App
    > DI
      StorageProvider
  > Data
    > DTOs
      - DailyBudgetDTO
      - SalaryBudgetDTO
      - TransactionItemDTO
    > Repositories
      > Impls
        - SalaryBudgetRepositoryImpl
  > Domain
    > Models
      - DailyBudget
      - SalaryBudget
      - TransactionItem
    > Repositories
      - SalaryBudgetRepository
      - UpdateValue
  > Helper
    > Constants
      - WidgetURL
    > DesignSystem
      - Color+
      - Font+
    > Extensions
      - Int+
      - Date+
 */

//
//  Coordinator.swift
//  Harubee
//
//  Created by 이정동 on 12/18/24.
//

import SwiftUI

enum AppPage: Hashable {
  // Onboarding
  case onboarding1, onboarding2, onboarding3
  case onboarding4(currentBalanceAmount: String)
  case onboarding5(fixedExpenses: [TransactionItem])
  case onboarding6
  
  // Main
  case today
  case periodlyCalendar
  case dailyCalendar
  case setting(salaryBudget: SalaryBudget)
  case fixedExpense
  case fixedIncome
}

enum Sheet: Identifiable {
  case harubeeAdjust(salaryBudget: SalaryBudget, DailyBudget: DailyBudget)
  case transactionInput(salaryBudget: SalaryBudget, DailyBudget: DailyBudget)
  case balanceAdjust(salaryBudget: SalaryBudget, DailyBudget: DailyBudget)
  case fixedExpenseManage // 콜백 필요
  case fixedIncomeModify  // 콜백 필요
  case dailyMemo(memo: String? = nil) // 콜백 필요
  
  var id: String { UUID().uuidString }
}

enum Root {
  case onboarding
  case main
}

@Observable
final class Coordinator {
  
  private(set) var root: Root
  var path: [AppPage] = []
  var sheet: Sheet?
  
  init() {
    let isOnboarding = UserDefaults.standard.object(forKey: "isOnboarding") as? Bool ?? true
    self.root = isOnboarding ? .onboarding : .main
  }
}

// MARK: - Navigation Method
extension Coordinator {
  func push(page: AppPage) {
    path.append(page)
  }
  
  func pop() {
    path.removeLast()
  }
  
  func popToRoot() {
    path.removeAll()
  }
  
  func presentSheet(_ sheet: Sheet) {
    self.sheet = sheet
  }
  
  func presentSheetFromWidget(_ sheet: Sheet) {
    switch root {
    case .onboarding: return
    case .main:
      path.removeAll()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.sheet = sheet
      }
    }
  }
  
  func dismissSheet() {
    self.sheet = nil
  }
  
  func switchRootView() {
    switch root {
    case .onboarding:
      root = .main
      UserDefaults.standard.set(false, forKey: "isOnboarding")
    case .main:
      root = .onboarding
      UserDefaults.standard.set(true, forKey: "isOnboarding")
    }
    
    path.removeAll()
  }
}

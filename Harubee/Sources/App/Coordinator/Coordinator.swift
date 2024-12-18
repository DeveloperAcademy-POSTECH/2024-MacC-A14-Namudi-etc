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
  case dailyCalendar(initialDate: Date)
  case setting(salaryBudget: SalaryBudget)
  case fixedExpense
  case fixedIncome
}

enum Sheet: Identifiable {
  case harubeeAdjust(salaryBudget: SalaryBudget, dailyBudget: DailyBudget)
  case transactionInput(salaryBudget: SalaryBudget, dailyBudget: DailyBudget)
  case balanceAdjust(salaryBudget: SalaryBudget, dailyBudget: DailyBudget)
  case fixedExpenseManage(day: Int, name: String, amount: String) // 콜백 필요
  case fixedIncomeModify(fixedIncomeAmount: String)  // 콜백 필요
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
  
  // 고정 지출 관리 화면에서 호출될 콜백 함수
  private var fixedExpenseManageCompletion: ((Int, String, String) -> Void)?
  // 고정 수입 화면에서 호출될 콜백 함수
  private var fixedIncomeModifyCompletion: ((String) -> Void)?
  // 일별 메모 화면에서 호출될 콜백 함수
  private var dailyMemoCompletion: ((String) -> Void)?
  
  init() {
    let isOnboarding = UserDefaults.standard.object(forKey: "isOnboarding") as? Bool ?? true
    self.root = isOnboarding ? .onboarding : .main
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
}

// MARK: - Sheet Method
extension Coordinator {
  
  private func presentSheet(_ sheet: Sheet) {
    self.sheet = sheet
  }
  
  /// 위젯을 통해서 지출 입력 화면으로 이동합니다
  /// - Parameters:
  ///   - salaryBudget: 이번 기간의 SalaryBudget
  ///   - dailyBudget: 오늘 날짜의 DailyBudget
  func presentTransactionInputSheetFromWidget(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) {
    switch root {
    case .onboarding: return
    case .main:
      path.removeAll()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.sheet = .transactionInput(
          salaryBudget: salaryBudget,
          dailyBudget: dailyBudget
        )
      }
    }
  }
  
  /// 지출 입력 화면으로 이동합니다
  /// - Parameters:
  ///   - salaryBudget: 이번 기간의 SalaryBudget
  ///   - dailyBudget: 오늘 날짜의 DailyBudget
  func presentTransactionInputSheet(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) {
    self.sheet = .transactionInput(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget
    )
  }
  
  /// 하루비 조정 화면으로 이동합니다
  /// - Parameters:
  ///   - salaryBudget: 이번 기간의 SalaryBudget
  ///   - dailyBudget: 오늘 날짜의 DailyBudget
  func presentHarubeeAdjustSheet(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) {
    self.sheet = .harubeeAdjust(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget
    )
  }
  
  /// 쓸 수 있는 돈 조정 화면으로 이동합니다
  /// - Parameters:
  ///   - salaryBudget: 이번 기간의 SalaryBudget
  ///   - dailyBudget: 오늘 날짜의 DailyBudget
  func presentBalanceAdjustSheet(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget
  ) {
    self.sheet = .balanceAdjust(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget
    )
  }
  
  /// 고정 지출 관리 화면으로 이동합니다
  /// - Parameters:
  ///   - day: 현재 고정 지출 일자
  ///   - name: 현재 고정 지출 이름
  ///   - amount: 현재 고정 지출 금액
  ///   - completion: 변경된 일자, 이름, 금액이 파라미터로 전달되는 콜백 함수
  func presentFixedExpenseManageSheet(
    day: Int,
    name: String,
    amount: String,
    completion: @escaping ((Int, String, String) -> Void)
  ) {
    self.fixedExpenseManageCompletion = completion
    self.presentSheet(.fixedExpenseManage(day: day, name: name, amount: amount))
  }
  
  /// 고정 수입 금액 변경 화면으로 이동합니다
  /// - Parameters:
  ///   - fixedIncomeAmount: 현재 고정 수입 금액
  ///   - completion: 변경된 고정 수입 금액이 파라미터로 전달되는 콜백 함수
  func presentFixedIncomeModifySheet(
    fixedIncomeAmount: String,
    completion: @escaping ((String) -> Void)
  ) {
    self.fixedIncomeModifyCompletion = completion
    self.presentSheet(.fixedIncomeModify(fixedIncomeAmount: fixedIncomeAmount))
  }
  
  /// 메모 추가, 수정 화면으로 이동합니다
  /// - Parameters:
  ///   - memo: 기존 메모
  ///   - completion: 변경된 메모가 파라미터로 전달되는 콜백 함수
  func presentDailyMemoSheet(
    memo: String? = nil,
    completion: @escaping ((String) -> Void)
  ) {
    self.dailyMemoCompletion = completion
    self.presentSheet(.dailyMemo(memo: memo))
  }
  
  func dismissSheet() {
    self.sheet = nil
  }
}

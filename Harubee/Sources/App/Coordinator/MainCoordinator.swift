//
//  MainCoordinator.swift
//  Harubee
//
//  Created by 이정동 on 12/20/24.
//

import SwiftUI

typealias MainCoordinatorProtocol = Navigatable & SheetPresentable
typealias MainAppPage = MainCoordinator.AppPage

@Observable
final class MainCoordinator: MainCoordinatorProtocol {
  
  // MARK: - Enum
  enum AppPage: Hashable {
    case today
    case periodlyCalendar
    case dailyCalendar(calendarViewModel: CalendarViewModel, initialDate: Date)
    case setting(salaryBudget: SalaryBudget)
    case fixedExpense(settingViewModel: SettingViewModel)
    case fixedIncome(settingViewModel: SettingViewModel)
    case appearanceOptions(settingViewModel: SettingViewModel)
  }
  
  enum Sheet: Identifiable {
    case harubeeAdjust(
      salaryBudget: SalaryBudget,
      dailyBudget: DailyBudget
    )  // 콜백 필요
    case transactionInput(
      salaryBudget: SalaryBudget,
      dailyBudget: DailyBudget,
      focus: TransactionFocusType = .expense
    )  // 콜백 필요
    case balanceAdjust(
      salaryBudget: SalaryBudget,
      dailyBudget: DailyBudget
    )  // 콜백 필요
    case fixedExpenseManage(day: Int, name: String, amount: String) // 콜백 필요
    case fixedIncomeModify(fixedIncomeAmount: String)  // 콜백 필요
    case dailyMemo(memo: String? = nil) // 콜백 필요
    
    var id: String { String(describing: self) }
  }
  
  
  // MARK: - Properties
  var path: [AppPage] = []
  var sheet: Sheet?
  
  
  // HarubeeAdjustView 콜백 함수
  private var harubeeAdjustCompletion: (() -> Void)?
  // TransactionInputView 콜백 함수
  private var transactionInputCompletion: (() -> Void)?
  // BalanceAdjustView 콜백 함수
  private var balanceAdjustCompletion: (() -> Void)?
  // FixedExpenseManageView 콜백 함수
  private var fixedExpenseManageCompletion: ((Int, String, String) -> Void)?
  // FixedIncomeModifyView 콜백 함수
  private var fixedIncomeModifyCompletion: ((String) -> Void)?
  // DailyMemoView 콜백 함수
  private var dailyMemoCompletion: ((String) -> Void)?
  
  
  // MARK: - Navigation Methods
  func push(_ page: AppPage) {
    path.append(page)
  }
  
  func pop() {
    path.removeLast()
  }
  
  func popToRoot() {
    path.removeAll()
  }
  
  
  // MARK: - Sheet Methods
  
  func presentSheet(_ sheet: Sheet) {
    self.sheet = sheet
  }
  
  func dismissSheet() {
    self.sheet = nil
  }
  
  /// 지출 입력 화면으로 이동합니다
  /// - Parameters:
  ///   - salaryBudget: 이번 기간의 SalaryBudget
  ///   - dailyBudget: 오늘 날짜의 DailyBudget
  func presentTransactionInputSheet(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget,
    focus: TransactionFocusType = .expense,
    completion: @escaping () -> Void
  ) {
    self.transactionInputCompletion = completion
    self.presentSheet(.transactionInput(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget,
      focus: focus
    ))
  }
  
  /// 하루비 조정 화면으로 이동합니다
  /// - Parameters:
  ///   - salaryBudget: 이번 기간의 SalaryBudget
  ///   - dailyBudget: 오늘 날짜의 DailyBudget
  func presentHarubeeAdjustSheet(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget,
    completion: @escaping () -> Void
  ) {
    self.harubeeAdjustCompletion = completion
    self.presentSheet(.harubeeAdjust(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget
    ))
  }
  
  /// 쓸 수 있는 돈 조정 화면으로 이동합니다
  /// - Parameters:
  ///   - salaryBudget: 이번 기간의 SalaryBudget
  ///   - dailyBudget: 오늘 날짜의 DailyBudget
  func presentBalanceAdjustSheet(
    salaryBudget: SalaryBudget,
    dailyBudget: DailyBudget,
    completion: @escaping () -> Void
  ) {
    self.balanceAdjustCompletion = completion
    self.presentSheet(.balanceAdjust(
      salaryBudget: salaryBudget,
      dailyBudget: dailyBudget
    ))
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
  
  func dismissHarubeeAdjustSheet() {
    self.harubeeAdjustCompletion?()
    self.dismissSheet()
  }
  
  func dismissTransactionInputSheet() {
    self.transactionInputCompletion?()
    self.dismissSheet()
  }
  
  func dismissBalanceAdjustSheet() {
    self.balanceAdjustCompletion?()
    self.dismissSheet()
  }
  
  func dismissFixedExpenseManageSheet(
    day: Int,
    name: String,
    amount: String
  ) {
    self.fixedExpenseManageCompletion?(day, name, amount)
    self.dismissSheet()
  }
  
  func dismissFixedIncomeModifySheet(
    fixedIncomeAmount: String
  ) {
    self.fixedIncomeModifyCompletion?(fixedIncomeAmount)
    self.dismissSheet()
  }
  
  func dismissDailyMemoSheet(
    memo: String
  ) {
    self.dailyMemoCompletion?(memo)
    self.dismissSheet()
  }
  
  
  // MARK: - View Build Methods
  
  func buildPage(_ page: AppPage) -> some View {
    switch page {
    case .today:
      TodayView(todayViewModel: DIContainer.shared.makeTodayViewModel())
    case .periodlyCalendar:
      PeriodlyCalendarView(
        viewModel: DIContainer.shared.makeCalendarViewModel()
      )
    case let .dailyCalendar(viewModel, initialDate):
      DailyCalendarView(viewModel: viewModel, initialDate: initialDate)
    case let .setting(salaryBudget):
      SettingView(
        settingViewModel: DIContainer.shared.makeSettingViewModel(
          salaryBudget: salaryBudget
        )
      )
    case let .fixedExpense(viewModel):
      FixedExpenseView(settingViewModel: viewModel)
    case let .fixedIncome(viewModel):
      FixedIncomeView(settingViewModel: viewModel)
    case let .appearanceOptions(settingViewModel: viewModel):
      AppearanceOptionsView(settingViewModel: viewModel)
    }
  }
  
  func buildSheet(_ sheet: Sheet) -> some View {
    switch sheet {
    case let .harubeeAdjust(salaryBudget, dailyBudget):
      HarubeeAdjustView(
        viewModel: DIContainer.shared.makeHarubeeAdjustViewModel(
          salaryBudget: salaryBudget,
          dailyBudget: dailyBudget
        )
      )
      .presentationDetents([.height(600)])
    case let .transactionInput(salaryBudget, dailyBudget, focus):
      TransactionInputView(
        viewModel: DIContainer.shared.makeTransactionInputViewModel(
          salaryBudget: salaryBudget,
          dailyBudget: dailyBudget
        ),
        transactionFocusType: focus
      )
      .presentationDetents([.height(600)])
    case let .balanceAdjust(salaryBudget, dailyBudget):
      BalanceAdjustView(
        viewModel: DIContainer.shared.makeBalanceAdjustViewModel(
          salaryBudget: salaryBudget,
          dailyBudget: dailyBudget
        )
      )
      .presentationDetents([.height(600)])
    case let .fixedExpenseManage(day, name, amount):
      FixedExpenseManageView(
        selectedDay: day,
        fixedExpenseName: name,
        fixedExpenseAmount: amount
      )
      .presentationDetents([.large])
    case let .fixedIncomeModify(fixedIncomeAmount):
      FixedIncomeModifyView(fixedIncomeAmount: fixedIncomeAmount)
      .presentationDetents([.height(497)])
    case let .dailyMemo(memo):
      DailyMemoView(existingMemo: memo)
      .presentationDetents([.fraction(0.25)])
    }
  }
}

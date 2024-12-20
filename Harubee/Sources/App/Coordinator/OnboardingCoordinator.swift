//
//  OnboardingCoordinator.swift
//  Harubee
//
//  Created by 이정동 on 12/20/24.
//

import SwiftUI

typealias OnboardingCoordinatorProtocol = Navigatable & SheetPresentable
typealias OnboardingAppPage = OnboardingCoordinator.AppPage

@Observable
final class OnboardingCoordinator: OnboardingCoordinatorProtocol {
  
  enum AppPage: Hashable {
    case onboarding1, onboarding2, onboarding3
    case onboarding4(currentBalanceAmount: String)
    case onboarding5(fixedExpenses: [TransactionItem])
    case onboarding6
  }
  
  enum Sheet: Identifiable {
    case fixedExpenseManage(day: Int, name: String, amount: String) // 콜백 필요
    
    var id: UUID { UUID() }
  }
  
  var path: [AppPage] = []
  var sheet: Sheet?
  
  // 고정 지출 관리 화면에서 호출될 콜백 함수
  private var fixedExpenseManageCompletion: ((Int, String, String) -> Void)?
  
  func push(_ page: AppPage) {
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
  
  func dismissSheet() {
    self.sheet = nil
  }
  
  func dismissFixedExpenseManageSheet(
    day: Int,
    name: String,
    amount: String
  ) {
    self.fixedExpenseManageCompletion?(day, name, amount)
    self.dismissSheet()
  }
  
  func buildPage(_ page: AppPage) -> some View {
    EmptyView()
  }
  
  func buildSheet(_ sheet: Sheet) -> some View {
    EmptyView()
  }
}

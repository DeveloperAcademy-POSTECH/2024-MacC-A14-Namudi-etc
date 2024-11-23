//
//  SettingViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

enum NotificationType {
  case harubee
  case expense
}

@Observable
final class SettingViewModel {
  struct State {
    var salaryBudget: SalaryBudget
    var harubeeNotificationTime: Date?
    var expenseNotificationTime: Date?
    var harubeeNotificationStatus: Bool?
    var expenseNotificationStatus: Bool?
  }
  
  enum Action {
    case toggleNotificationStatus(NotificationType, Bool)
    case updateNotificationTime(NotificationType, Date)
    case fixedIncomeSaveButtonTapped(Int?, Int?)
    case updateFixedExpenses([TransactionItem])
  }
  
  private(set) var state: State
  
  private let budgetUseCase: BudgetUseCase
  
  init(
    budgetUseCase: BudgetUseCase,
    salaryBudget: SalaryBudget
  ) {
    self.budgetUseCase = budgetUseCase
    self.state = State(salaryBudget: salaryBudget)
    fetchNotificationData()
  }
  
  // MARK: - Public Methods (유저 액션 핸들러)
  func send(_ action: Action) {
    switch action {
    case .toggleNotificationStatus(let type, let newStatus):
      saveNotificationStatus(notificationType: type, newStatus: newStatus)
      
    case .updateNotificationTime(let type, let time):
      saveNotificationTime(notificationType: type, time: time)

    case .fixedIncomeSaveButtonTapped(let incomeDay, let incomeAmount):
      if let incomeDay = incomeDay {
        self.updateFixedIncomeDay(incomeDay)
      }
      
      if let incomeAmount = incomeAmount {
        self.updateFixedIncomeAmount(incomeAmount)
      }
      
    case let .updateFixedExpenses(items):
      self.updateFixedExpenses(items)
    }
  }
  
  // MARK: - Private Methods (유즈케이스 호출 메소드)
  private func saveNotificationTime(
    notificationType: NotificationType,
    time: Date
  ) {
    switch notificationType {
    case .harubee:
      budgetUseCase.setTodayHarubeeNotificationTime(time: time)
    case .expense:
      budgetUseCase.setExpenseNotificationTime(time: time)
    }
  }
  
  private func saveNotificationStatus(
    notificationType: NotificationType,
    newStatus: Bool
  ) {
    switch notificationType {
    case .harubee:
      budgetUseCase.setTodayHarubeeNotificationStatus(newStatus)
    case .expense:
      budgetUseCase.setExpenseNotificationStatus(newStatus)
    }
  }
  
  
  private func fetchNotificationData() {

    let harubeeNotificationTime = try? budgetUseCase.getTodayHarubeeNotificationTime()
    let expenseNotificationTime = try? budgetUseCase.getExpenseNotificationTime()
    let harubeeNotificationStatus = try? budgetUseCase.getTodayHarubeeNotificationStatus()
    let expenseNotificationStatus = try? budgetUseCase.getExpenseNotificationStatus()
    
    self.state.harubeeNotificationTime = harubeeNotificationTime
    self.state.expenseNotificationTime = expenseNotificationTime
    self.state.harubeeNotificationStatus = harubeeNotificationStatus
    self.state.expenseNotificationStatus = expenseNotificationStatus
  }
  
  private func updateFixedIncomeDay(_ incomeDay: Int) {
    do {
      let newSalaryBudget = try budgetUseCase.setIncomeDay(
        day: incomeDay,
        salaryBudget: self.state.salaryBudget
      )
      self.state.salaryBudget = newSalaryBudget
    } catch {
      print(#function, "error: \(error.localizedDescription)")
    }
  }
  
  private func updateFixedIncomeAmount(_ incomeAmount: Int) {
    do {
      let newSalaryBudget = try budgetUseCase.updateFixedIncome(
        salaryBudget: self.state.salaryBudget,
        newIncome: incomeAmount
      )
      self.state.salaryBudget = newSalaryBudget
    } catch {
      print(#function, "error: \(error.localizedDescription)")
    }
  }
  
  private func updateFixedExpenses(_ fixedExpenses: [TransactionItem]) {
    do {
      let updatedSalaryBudget = try budgetUseCase.updateFixedExpenses(
        salaryBudget: self.state.salaryBudget,
        expenses: fixedExpenses
      )
      self.state.salaryBudget = updatedSalaryBudget
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
}

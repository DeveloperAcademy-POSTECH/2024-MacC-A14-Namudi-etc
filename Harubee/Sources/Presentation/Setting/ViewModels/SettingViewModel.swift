//
//  SettingViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import SwiftUI

enum NotificationType {
  case harubee
  case expense
}

@Observable
final class SettingViewModel {
  struct State {
    var salaryBudget: SalaryBudget
    var harubeeNotificationTime: Date = Date()
    var expenseNotificationTime: Date = Date()
    var harubeeNotificationStatus: Bool = false
    var expenseNotificationStatus: Bool = false
  }
  
  enum Action {
    case viewDidLoad
    case onChangeNotificationTime(notificationType: NotificationType, Date)
    case onChangeNotificationStatus(notificationType: NotificationType, Bool)
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
  }
  
  // MARK: - Public Methods (유저 액션 핸들러)
  func send(_ action: Action) {
    switch action {
    case .viewDidLoad:
      fetchNotificationData()
      
    case .onChangeNotificationTime(notificationType: let type, let time):
      onChangeNotificationTime(notificationType: type, time: time)
      
    case .onChangeNotificationStatus(notificationType: let type, let status):
      onChangeNotificationStatus(notificationType: type, status: status)

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
  private func onChangeNotificationTime(
    notificationType: NotificationType,
    time: Date
  ) {
    switch notificationType {
    case .harubee:
      // 알림 시간 저장
      budgetUseCase.setTodayHarubeeNotificationTime(time: time)
      // 토글이 On이라면
      if state.harubeeNotificationStatus {
        // 알림 등록
        NotificationManager.shared.scheduleNotification(
          time: time, notificationType: .harubee
        )
      }
    case .expense:
      // 알림 시간 저장
      budgetUseCase.setExpenseNotificationTime(time: time)
      // 토글이 On이라면
      if state.expenseNotificationStatus {
        // 알림 등록
        NotificationManager.shared.scheduleNotification(
          time: time, notificationType: .expense
        )
      }
    }
  }
  
  private func onChangeNotificationStatus(
    notificationType: NotificationType,
    status: Bool
  ) {
    switch notificationType {
    case .harubee:
      budgetUseCase.setTodayHarubeeNotificationStatus(status)
      if status {
        NotificationManager.shared.scheduleNotification(
          time: state.harubeeNotificationTime,
          notificationType: .harubee
        )
      } else {
        NotificationManager.shared.deleteNotification(
          notificationType: .harubee
        )
      }
    case .expense:
      budgetUseCase.setExpenseNotificationStatus(status)
      if status {
        NotificationManager.shared.scheduleNotification(
          time: state.expenseNotificationTime,
          notificationType: .expense
        )
      } else {
        NotificationManager.shared.deleteNotification(
          notificationType: .expense
        )
      }
    }
  }
  
  private func fetchNotificationData() {

    let harubeeNotificationTime = try? budgetUseCase.getTodayHarubeeNotificationTime()
    let expenseNotificationTime = try? budgetUseCase.getExpenseNotificationTime()
    let harubeeNotificationStatus = try? budgetUseCase.getTodayHarubeeNotificationStatus()
    let expenseNotificationStatus = try? budgetUseCase.getExpenseNotificationStatus()
    
    self.state.harubeeNotificationTime = harubeeNotificationTime ?? Date()
    self.state.expenseNotificationTime = expenseNotificationTime ?? Date()
    self.state.harubeeNotificationStatus = harubeeNotificationStatus ?? false
    self.state.expenseNotificationStatus = expenseNotificationStatus ?? false
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

extension SettingViewModel {
  
  // MARK: - Binding
  enum BindingKey {
    case harubeeNotificationTime
    case expenseNotificationTime
    case harubeeNotificationStatus
    case expenseNotificationStatus
  }
  
  func binding<T>(_ key: BindingKey) -> SwiftUI.Binding<T> {
    switch key {
    case .harubeeNotificationTime:
      return Binding(
        get: { self.state.harubeeNotificationTime as! T },
        set: { self.state.harubeeNotificationTime = $0 as! Date }
      )
    case .expenseNotificationTime:
      return Binding(
        get: { self.state.expenseNotificationTime as! T },
        set: { self.state.expenseNotificationTime = $0 as! Date }
      )
    case .harubeeNotificationStatus:
      return Binding(
        get: { self.state.harubeeNotificationStatus as! T },
        set: { self.state.harubeeNotificationStatus = $0 as! Bool }
      )
    case .expenseNotificationStatus:
      return Binding(
        get: { self.state.expenseNotificationStatus as! T },
        set: { self.state.expenseNotificationStatus = $0 as! Bool }
      )
    }
  }
}

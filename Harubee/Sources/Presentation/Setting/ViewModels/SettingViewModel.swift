//
//  SettingViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import SwiftUI


@Observable
final class SettingViewModel {
  struct State {
    var salaryBudget: SalaryBudget
  }
  
  enum Action {
    case fixedIncomeSaveButtonTapped(Int?, Int?)
    case updateFixedExpenses([TransactionItem])
    case resetDataButtonTapped
  }
  
  private(set) var state: State
  
  private let budgetUseCase: BudgetUseCase
  private let appSettingsUseCase: AppSettingsUseCase
  private let analyticsUseCase: AnalyticsUseCase
  
  private var harubeeNotificationTime: Date = Date()
  private var expenseNotificationTime: Date = Date()
  private var harubeeNotificationStatus: Bool = false
  private var expenseNotificationStatus: Bool = false
  
  init(
    budgetUseCase: BudgetUseCase,
    appSettingsUseCase: AppSettingsUseCase,
    analyticsUseCase: AnalyticsUseCase,
    salaryBudget: SalaryBudget
  ) {
    self.budgetUseCase = budgetUseCase
    self.appSettingsUseCase = appSettingsUseCase
    self.analyticsUseCase = analyticsUseCase
    
    self.state = State(salaryBudget: salaryBudget)
    self.fetchNotificationData()
  }
  
  // MARK: - Public Methods (유저 액션 핸들러)
  func send(_ action: Action) {
    switch action {
    case .fixedIncomeSaveButtonTapped(let incomeDay, let incomeAmount):
      if let incomeDay = incomeDay {
        self.updateFixedIncomeDay(incomeDay)
      }
      
      if let incomeAmount = incomeAmount {
        self.updateFixedIncomeAmount(incomeAmount)
      }
      
      analyticsUseCase.trackEvent(
        event: .buttonTap(name: "고정 수입 변경")
      )
      
    case let .updateFixedExpenses(items):
      self.updateFixedExpenses(items)
      
    case .resetDataButtonTapped:
      do {
        try budgetUseCase.deleteAllSalaryBudgets()
        analyticsUseCase.trackEvent(
          event: .buttonTap(name: "데이터 초기화")
        )
        
      } catch {
        print("Reset Data Error: \(error.localizedDescription)")
      }
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
      appSettingsUseCase.setTodayHarubeeNotificationTime(time: time)
      // 토글이 On이라면
      if harubeeNotificationStatus {
        // 알림 등록
        NotificationManager.shared.scheduleNotification(
          time: time, notificationType: .harubee
        )
      }
    case .expense:
      // 알림 시간 저장
      appSettingsUseCase.setExpenseNotificationTime(time: time)
      // 토글이 On이라면
      if expenseNotificationStatus {
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
      appSettingsUseCase.setTodayHarubeeNotificationStatus(status)
      if status {
        NotificationManager.shared.scheduleNotification(
          time: harubeeNotificationTime,
          notificationType: .harubee
        )
      } else {
        NotificationManager.shared.deleteNotification(
          notificationType: .harubee
        )
      }
    case .expense:
      appSettingsUseCase.setExpenseNotificationStatus(status)
      if status {
        NotificationManager.shared.scheduleNotification(
          time: expenseNotificationTime,
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

    let harubeeNotificationTime = appSettingsUseCase.getTodayHarubeeNotificationTime()
    let expenseNotificationTime = appSettingsUseCase.getExpenseNotificationTime()
    let harubeeNotificationStatus = appSettingsUseCase.getTodayHarubeeNotificationStatus()
    let expenseNotificationStatus = appSettingsUseCase.getExpenseNotificationStatus()
    
    self.harubeeNotificationTime = harubeeNotificationTime ?? Date()
    self.expenseNotificationTime = expenseNotificationTime ?? Date()
    self.harubeeNotificationStatus = harubeeNotificationStatus ?? false
    self.expenseNotificationStatus = expenseNotificationStatus ?? false
  }
  
  private func updateFixedIncomeDay(_ incomeDay: Int) {
    do {
      let newSalaryBudget = try budgetUseCase.updateIncomeDay(
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
        get: { self.harubeeNotificationTime as! T },
        set: {
          self.harubeeNotificationTime = $0 as! Date
          self.onChangeNotificationTime(
            notificationType: .harubee,
            time: $0 as! Date
          )
        }
      )
    case .expenseNotificationTime:
      return Binding(
        get: { self.expenseNotificationTime as! T },
        set: {
          self.expenseNotificationTime = $0 as! Date
          self.onChangeNotificationTime(
            notificationType: .expense,
            time: $0 as! Date
          )
        }
      )
    case .harubeeNotificationStatus:
      return Binding(
        get: { self.harubeeNotificationStatus as! T },
        set: {
          self.harubeeNotificationStatus = $0 as! Bool
          self.onChangeNotificationStatus(
            notificationType: .harubee,
            status: $0 as! Bool
          )
        }
      )
    case .expenseNotificationStatus:
      return Binding(
        get: { self.expenseNotificationStatus as! T },
        set: {
          self.expenseNotificationStatus = $0 as! Bool
          self.onChangeNotificationStatus(
            notificationType: .expense,
            status: $0 as! Bool
          )
        }
      )
    }
  }
}

// MARK: - Hashable
extension SettingViewModel: Hashable {
  var id: String { String(describing: self) }
  
  static func == (lhs: SettingViewModel, rhs: SettingViewModel) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

// MARK: - Enumeration
enum AppearanceType: Int, CaseIterable, Identifiable {
  case automatic, light, dark
  
  var id: Int { self.rawValue }
  
  var name: String {
    switch self {
    case .automatic: return "시스템"
    case .light: return "라이트"
    case .dark: return "다크"
    }
  }
  
  var colorScheme: ColorScheme? {
    switch self {
    case .automatic: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}

enum NotificationType {
  case harubee
  case expense
}

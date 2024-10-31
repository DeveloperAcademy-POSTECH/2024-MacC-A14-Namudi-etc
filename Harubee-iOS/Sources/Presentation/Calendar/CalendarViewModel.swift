//
//  CalendarViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Domain
import Foundation

@Observable
final class CalendarViewModel {
  struct State {
    
  }
  
  enum Action {
    case onAppear
    case moveNextPeriod
    case movePreviousPeriod
    case onDateSelected(Date)
    case onMoveToToday
  }
  
  private enum Effect {
    case setSalaryBudget(SalaryBudget)
    case setError(Error)
  }
  
  // MARK: - Properties
  private(set) var state = State()
  
  
  init() {}
  
  // MARK: - Public Methods
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      print("onAppear")
    case .moveNextPeriod:
      print("moveNextPeriod")
    case .movePreviousPeriod:
      print("movePreviousPeriod")
    case .onDateSelected(_):
      print("onDateSelected")
    case .onMoveToToday:
      print("onMoveToToday")
    }
  }
  
  private func receive(_ effect: Effect) {
    switch effect {
    case .setSalaryBudget:
      print("setSalaryBudget")
    case .setError:
      print("setError")
    }
  }
  
  // MARK: - Private Methods
}

//
//  TodayViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain

@Observable
final class TodayViewModel {
  // MARK: - ViewState
  struct ViewState {
    var todayDate = Date()
    var todayHarubee = 36000
    var averageHarubee = 57400
    var weeklyStreaks = [DailyBudget]()
    
    var tempWeeklyStreaks = ["19(일)", "20(월)", "21(화)", "22(수)", "23(목)", "24(금)", "25(토)"]
  }
  
  // MARK: - Action
  enum Action {
    
  }
  
  private(set) var viewState: ViewState = .init()
  
  init() {}
  
  // MARK: - Effect
  func effect(_ action: Action) {
    switch action {
      // code
    }
  }
}

extension TodayViewModel {
  // MARK: - Private Function
}

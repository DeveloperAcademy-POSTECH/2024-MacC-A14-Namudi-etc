//
//  TodayViewModel.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

@Observable
final class TodayViewModel {
  // MARK: - ViewState
  struct ViewState {
    var todayDate = Date()
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

//
//  SwiftDataError.swift
//  Data
//
//  Created by 이정동 on 10/29/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

enum SwiftDataError: LocalizedError {
  case fetchError
  case deleteError
  case modelNotFound
  
  var errorDescription: String {
    switch self {
    case .fetchError:
      "Fetch error"
    case .deleteError:
      "Delete error"
    case .modelNotFound:
      "Model not found"
    }
  }
}

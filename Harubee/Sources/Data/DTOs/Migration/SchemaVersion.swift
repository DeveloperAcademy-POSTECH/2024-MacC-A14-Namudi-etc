//
//  SchemaVersion.swift
//  Harubee
//
//  Created by 이정동 on 12/16/24.
//

import Foundation
import SwiftData


enum SchemaV2: VersionedSchema {
  static var versionIdentifier: Schema.Version = .init(2, 0, 0)
  
  static var models: [any PersistentModel.Type] {
    [
      SalaryBudgetDTO.self,
      DailyBudgetDTO.self,
      TransactionItemDTO.self
    ]
  }
}

enum SchemaV1: VersionedSchema {
  static var versionIdentifier: Schema.Version = .init(1, 0, 0)
  
  static var models: [any PersistentModel.Type] {
    [
      SalaryBudgetDTO.self,
      DailyBudgetDTO.self,
      TransactionItemDTO.self
    ]
  }
}

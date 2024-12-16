//
//  MigrationPlan.swift
//  Harubee
//
//  Created by 이정동 on 12/16/24.
//

import Foundation
import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [
      SchemaV1.self,
      SchemaV2.self
    ]
  }
  
  static var stages: [MigrationStage] {
    [migrateV1toV2]
  }
  
  static let migrateV1toV2 = MigrationStage.custom(
    fromVersion: SchemaV1.self,
    toVersion: SchemaV2.self,
    willMigrate: nil,
    didMigrate: { context in
      let transactionItems = try context.fetch(
        FetchDescriptor<TransactionItemDTO>()
      )
      
      for item in transactionItems {
        item.day = item.date.day
      }
      
      try context.save()
    }
  )
}


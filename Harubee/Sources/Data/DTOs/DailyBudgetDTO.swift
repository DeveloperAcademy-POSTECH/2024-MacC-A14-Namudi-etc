//
//  DailyBudgetDTO.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import SwiftData

typealias DailyBudgetDTO = SchemaV2.DailyBudgetDTO

extension SchemaV2 {
  @Model
  final class DailyBudgetDTO {
    @Attribute(.unique) var identifier: String
    var date: Date
    var harubee: Int?
    var memo: [String]
    var expense: Int?
    var income: Int?
    
    init(
      id: String,
      date: Date,
      harubee: Int? = nil,
      memo: [String],
      expense: Int? = nil,
      income: Int? = nil
    ) {
      self.identifier = id
      self.date = date
      self.harubee = harubee
      self.memo = memo
      self.expense = expense
      self.income = income
    }
    
    convenience init(_ data: DailyBudget) {
      self.init(
        id: data.id,
        date: data.date,
        harubee: data.harubee,
        memo: data.memo,
        expense: data.expense,
        income: data.income
      )
    }
  }
}

extension SchemaV1 {
  @Model
  final class DailyBudgetDTO {
    @Attribute(.unique) var identifier: String
    var date: Date
    var harubee: Int?
    var memo: [String]
    var expense: Int?
    var income: Int?
    
    init(
      id: String,
      date: Date,
      harubee: Int? = nil,
      memo: [String],
      expense: Int? = nil,
      income: Int? = nil
    ) {
      self.identifier = id
      self.date = date
      self.harubee = harubee
      self.memo = memo
      self.expense = expense
      self.income = income
    }
    
    convenience init(_ data: DailyBudget) {
      self.init(
        id: data.id,
        date: data.date,
        harubee: data.harubee,
        memo: data.memo,
        expense: data.expense,
        income: data.income
      )
    }
  }
}

extension DailyBudgetDTO {
  func toEntity() -> DailyBudget {
    return DailyBudget(
      id: self.identifier,
      date: self.date,
      harubee: self.harubee,
      memo: self.memo,
      expense: self.expense,
      income: self.income
    )
  }
}

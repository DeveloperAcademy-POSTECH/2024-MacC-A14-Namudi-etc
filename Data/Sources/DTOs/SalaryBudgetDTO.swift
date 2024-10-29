//
//  SalaryBudgetDTO.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftData

@Model
public final class SalaryBudgetDTO {
  @Attribute(.unique) var identifier: String
  var startDate: Date
  var endDate: Date
  var fixedIncome: Int
  @Relationship(deleteRule: .cascade) var fixedExpenses: [TransactionItemDTO]
  var balance: Int
  var defaultHarubee: Double
  @Relationship(deleteRule: .cascade) var dailyBudgets: [DailyBudgetDTO]
  
  public init(
    id: String,
    startDate: Date,
    endDate: Date,
    fixedIncome: Int,
    fixedExpenses: [TransactionItem],
    balance: Int,
    defaultHarubee: Double,
    dailyBudgets: [DailyBudget]
  ) {
    self.identifier = id
    self.startDate = startDate
    self.endDate = endDate
    self.fixedIncome = fixedIncome
    self.fixedExpenses = fixedExpenses.map { TransactionItemDTO($0) }
    self.balance = balance
    self.defaultHarubee = defaultHarubee
    self.dailyBudgets = dailyBudgets.map { DailyBudgetDTO($0) }
  }
  
  public convenience init(_ data: SalaryBudget) {
    self.init(
      id: data.id,
      startDate: data.startDate,
      endDate: data.endDate,
      fixedIncome: data.fixedIncome,
      fixedExpenses: data.fixedExpenses,
      balance: data.balance,
      defaultHarubee: data.defaultHarubee,
      dailyBudgets: data.dailyBudgets
    )
  }
}

extension SalaryBudgetDTO {
  public func toEntity() -> SalaryBudget {
    return SalaryBudget(
      id: self.identifier,
      startDate: self.startDate,
      endDate: self.endDate,
      fixedIncome: self.fixedIncome,
      fixedExpenses: self.fixedExpenses.map { $0.toEntity() },
      balance: self.balance,
      defaultHarubee: self.defaultHarubee,
      dailyBudgets: self.dailyBudgets.map { $0.toEntity() }
    )
  }
}

//
//  DailyBudgetRepositoryImpl.swift
//  Data
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftData


public final class DailyBudgetRepositoryImpl: DailyBudgetRepository {
  
  private let modelContext: ModelContext
  
  public init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  public func readByDate(_ date: Date) throws -> DailyBudget? {
    print("Impl:", #function)
    
    let predicate = #Predicate<DailyBudgetDTO> { $0.date == date }
    let descriptor = FetchDescriptor(predicate: predicate)
    do {
      let data = try modelContext.fetch(descriptor)
      return data.first?.toEntity()
    } catch {
      throw SwiftDataError.fetchError
    }
  }
  
  public func updateDailyBudget(
    _ id: String,
    harubee: UpdateValue<Int?> = .keep,
    expence: UpdateValue<Int?> = .keep,
    income: UpdateValue<Int?> = .keep,
    memo: UpdateValue<[String]> = .keep
  ) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    
    if case .set(let harubee) = harubee { model.harubee = harubee }
    if case .set(let expense) = expence { model.expense = expense }
    if case .set(let income) = income { model.income = income }
    if case .set(let memo) = memo { model.memo = memo }
  }
  
  public func updateHarubee(_ id: String, harubee: Int) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.harubee = harubee
  }
  
  public func updateExpense(_ id: String, expense: Int) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.expense = expense
  }
  
  public func updateIncome(_ id: String, income: Int) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.income = income
  }
  
  public func updateMemo(_ id: String, memo: [String]) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.memo = memo
  }
}

extension DailyBudgetRepositoryImpl {
  private func readById(_ id: String) throws -> DailyBudgetDTO? {
    print("Impl:", #function)
    
    let predicate = #Predicate<DailyBudgetDTO> { $0.identifier == id }
    let descriptor = FetchDescriptor(predicate: predicate)
    do {
      let data = try modelContext.fetch(descriptor)
      return data.first
    } catch {
      throw SwiftDataError.fetchError
    }
  }
}

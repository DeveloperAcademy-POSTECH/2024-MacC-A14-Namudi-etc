//
//  DailyBudgetRepositoryImpl.swift
//  Data
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import SwiftData


final class DailyBudgetRepositoryImpl: DailyBudgetRepository {
  
  private let modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  func readByDate(_ date: Date) throws -> DailyBudget? {
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
  
  @discardableResult
  func updateDailyBudget(
    _ id: String,
    harubee: UpdateValue<Int?> = .keep,
    expence: UpdateValue<Int?> = .keep,
    income: UpdateValue<Int?> = .keep,
    memo: UpdateValue<[String]> = .keep
  ) throws -> DailyBudget {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    
    if case .set(let harubee) = harubee { model.harubee = harubee }
    if case .set(let expense) = expence { model.expense = expense }
    if case .set(let income) = income { model.income = income }
    if case .set(let memo) = memo { model.memo = memo }
    
    return model.toEntity()
  }
  
  @discardableResult
  func updateHarubee(_ id: String, harubee: Int?) throws -> DailyBudget {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    model.harubee = harubee
    
    return model.toEntity()
  }
  
  @discardableResult
  func updateTransaction(
    _ id: String,
    expense: Int?,
    income: Int?
  ) throws -> DailyBudget {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    model.expense = expense
    model.income = income
    
    return model.toEntity()
  }
  
  @discardableResult
  func updateMemo(_ id: String, memo: [String]) throws -> DailyBudget {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    model.memo = memo
    
    return model.toEntity()
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

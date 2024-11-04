//
//  SalaryBudgetRepositoryImpl.swift
//  Data
//
//  Created by 이정동 on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import Domain
import SwiftData

public final class SalaryBudgetRepositoryImpl: SalaryBudgetRepository {
  
  private let modelContext: ModelContext
  
  public init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  public func create(_ salaryBudget: SalaryBudget) {
    print("Impl:", #function)
    
    let model = SalaryBudgetDTO(salaryBudget)
    modelContext.insert(model)
  }
  
  public func readAll() throws -> [SalaryBudget] {
    print("Impl:", #function)
    
    let sort = SortDescriptor(\SalaryBudgetDTO.startDate, order: .forward)
    let descriptor = FetchDescriptor(sortBy: [sort])
    
    do {
      let datas = try modelContext.fetch(descriptor)
      return datas.map { $0.toEntity() }
    } catch {
      throw SwiftDataError.fetchError
    }
  }
  
  public func readByTargetDateContaining(_ targetDate: Date) throws -> SalaryBudget? {
    print("Impl:", #function)
    
    let predicate = #Predicate<SalaryBudgetDTO> { $0.startDate <= targetDate && $0.endDate >= targetDate }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      let data = try modelContext.fetch(descriptor).first
      return data?.toEntity()
    } catch {
      throw SwiftDataError.fetchError
    }
  }
  
  public func readByStartDate(_ startDate: Date) throws -> SalaryBudget? {
    print("Impl:", #function)
    
    let predicate = #Predicate<SalaryBudgetDTO> { $0.startDate == startDate }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      let data = try modelContext.fetch(descriptor).first
      return data?.toEntity()
    } catch {
      throw SwiftDataError.fetchError
    }
  }
  
  @discardableResult
  public func updateSalaryBudget(
    _ id: String,
    fixedIncome: UpdateValue<Int> = .keep,
    fixedExpenses: UpdateValue<[TransactionItem]> = .keep,
    balance: UpdateValue<Int> = .keep,
    defaultHarubee: UpdateValue<Double> = .keep
  ) throws -> SalaryBudget {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    
    if case .set(let fixedIncome) = fixedIncome { model.fixedIncome = fixedIncome }
    if case .set(let fixedExpenses) = fixedExpenses {
      model.fixedExpenses.forEach { modelContext.delete($0) }
      model.fixedExpenses = fixedExpenses.map { TransactionItemDTO($0) }
    }
    if case .set(let balance) = balance { model.balance = balance }
    if case .set(let defaultHarubee) = defaultHarubee {
      model.defaultHarubee = defaultHarubee
    }
    
    return model.toEntity()
  }
  
  @discardableResult
  public func updateFixedIncome(
    _ id: String,
    fixedIncome: Int
  ) throws -> SalaryBudget{
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    model.fixedIncome = fixedIncome
    
    return model.toEntity()
  }
  
  @discardableResult
  public func updateFixedExpenses(
    _ id: String,
    fixedExpenses: [TransactionItem]
  ) throws -> SalaryBudget{
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    model.fixedExpenses.forEach { modelContext.delete($0) }
    model.fixedExpenses = fixedExpenses.map { TransactionItemDTO($0) }
    
    return model.toEntity()
  }
  
  @discardableResult
  public func updateBalance(_ id: String, balance: Int) throws -> SalaryBudget{
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    model.balance = balance
    
    return model.toEntity()
  }
  
  @discardableResult
  public func updateDefaultHarubee(
    _ id: String,
    defaultHarubee: Double
  ) throws -> SalaryBudget{
    print("Impl:", #function)
    
    guard let model = try readById(id) else { throw SwiftDataError.modelNotFound }
    model.defaultHarubee = defaultHarubee
    
    return model.toEntity()
  }
  
  public func deleteById(_ id: String) throws {
    print("Impl:", #function)

    guard let model = try readById(id) else { return }
    modelContext.delete(model)    
  }
}


extension SalaryBudgetRepositoryImpl {
  private func readById(_ id: String) throws -> SalaryBudgetDTO? {
    print("Impl:", #function)
    
    let predicate = #Predicate<SalaryBudgetDTO> { $0.identifier == id }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      let data = try modelContext.fetch(descriptor).first
      return data
    } catch {
      throw SwiftDataError.fetchError
    }
  }
}

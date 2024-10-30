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
  
  public func updateFixedIncome(_ id: String, fixedIncome: Int) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.fixedIncome = fixedIncome
    
    return
  }
  
  public func updateFixedExpenses(_ id: String, fixedExpenses: [TransactionItem]) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.fixedExpenses = fixedExpenses.map { TransactionItemDTO($0) }
    
    return
  }
  
  public func updateBalance(_ id: String, balance: Int) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.balance = balance
    
    return
  }
  
  public func updateDefaultHarubee(_ id: String, defaultHarubee: Double) throws {
    print("Impl:", #function)
    
    guard let model = try readById(id) else { return }
    model.defaultHarubee = defaultHarubee
    
    return
  }
  
  public func deleteById(_ id: String) throws {
    print("Impl:", #function)

    guard let model = try readById(id) else { return }
    modelContext.delete(model)    
  }
  
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

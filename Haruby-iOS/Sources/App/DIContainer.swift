//
//  DIContainer.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private var dependencies: [String: Any] = [:]
    
    private init() {
        self.registerDependencies()
    }
    
    private func register<T>(_ type: T.Type, dependency: T) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
    
    private func registerDependencies() {
        self.register(
            SalaryBudgetRepository.self,
            dependency: SalaryBudgetRepositoryImpl()
        )
        
        self.register(
            DailyBudgetRepository.self,
            dependency: DailyBudgetRepositoryImpl()
        )
    }
}

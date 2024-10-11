//
//  SalaryBudgetRepository.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import Foundation
import RxSwift


protocol SalaryBudgetRepository: AnyObject {
    func create(_ salaryBudget: SalaryBudget) -> Observable<Void>
    func fetch() -> Observable<[SalaryBudget]>
    func update(_ salaryBudget: SalaryBudget) -> Observable<Void>
    func delete(_ salaryBudget: SalaryBudget) -> Observable<Void>
}

//
//  AppDelegate.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/3/24.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let disposeBag = DisposeBag()
    private lazy var salaryBudgetRepository: SalaryBudgetRepository = {
        return DIContainer.shared.resolve(SalaryBudgetRepository.self)!
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaultsManager.setIncomeDate(19)
        initializeBudget()
        return true
    }
    
    private func initializeBudget() {
        let incomeDate = UserDefaultsManager.getIncomeDate()
        let (startDate, endDate) = BudgetManager.calculateBudgetPeriod(incomeDate: incomeDate)
        checkAndCreateSalaryBudget(startDate: startDate, endDate: endDate)
    }
    
    private func checkAndCreateSalaryBudget(startDate: Date, endDate: Date) {
        salaryBudgetRepository.read(startDate)
            .flatMap { existingBudget -> Observable<Void> in
                guard existingBudget == nil else {
                    return Observable.just(())
                }
                let newSalaryBudget = BudgetManager.createSalaryBudget(startDate: startDate, endDate: endDate)
                return self.salaryBudgetRepository.create(newSalaryBudget)
            }
            .subscribe(onDisposed: {})
            .disposed(by: disposeBag)
    }
}

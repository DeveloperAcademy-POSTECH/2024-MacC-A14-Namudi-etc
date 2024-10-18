//
//  HarubyCalculatorCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit

final class CalculatorCoordinator: BaseCoordinator {
    let salaryBudget: SalaryBudget
    
    init(navigationController: UINavigationController, salaryBudget: SalaryBudget) {
        self.salaryBudget = salaryBudget
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        // TODO: 리액터에 데이터 전달 필요
        let reactor = CalculatorViewReactor(coordinator: self)
        let vc = CalculatorViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

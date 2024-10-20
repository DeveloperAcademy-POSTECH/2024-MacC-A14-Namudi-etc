//
//  TransactionInputCoordinator.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/20/24.
//

import UIKit

final class TransactionInputCoordinator: BaseCoordinator {
    
    let dailyBudget: DailyBudget
    
    init(navigationController: UINavigationController, dailyBudget: DailyBudget) {
        self.dailyBudget = dailyBudget
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let reactor = TransactionInputViewReactor(dailyBudget: dailyBudget)
        let vc = TransactionInputViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

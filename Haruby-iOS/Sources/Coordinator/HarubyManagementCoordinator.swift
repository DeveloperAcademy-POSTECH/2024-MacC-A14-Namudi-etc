//
//  HarubyManagementCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit

class HarubyManagementCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Parents: \(String(describing: parentCoordinator))")
        let vc = HarubyManagementViewController(reactor: HarubyManagementReactor(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAppSettings() {
        let vc = AppSettingsViewController(reactor: AppSettingsReactor())
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFixedIncomeManagement() {
        let vc = FixedIncomeManagementViewController(reactor: FixedIncomeManagementReactor())
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFixedExpenseManagement() {
        let vc = FixedExpenseManagementViewController(reactor: FixedExpenseManagementReactor())
        navigationController.pushViewController(vc, animated: true)
    }
}


//
//  MainCoordinator.swift
//  CoordinatorPractice-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Parents: \(String(describing: parentCoordinator))")
        let reactor = MainViewReactor(coordinator: self)
        let vc = MainViewController()
        vc.reactor = reactor
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCalculatorView() {
        print(#function)
        let coordinator = CalculatorCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showCalendarView() {
        let coordinator = CalendarCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showManagementView() {
        let coordinator = ManagementCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}

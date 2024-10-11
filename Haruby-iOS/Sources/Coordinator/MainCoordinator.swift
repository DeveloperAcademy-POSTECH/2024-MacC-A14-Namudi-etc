//
//  MainCoordinator.swift
//  CoordinatorPractice-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

class MainCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        print("main coordinator start")
        let vc = MainViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("main coordinator deinit")
    }
    
    func showCalculatorViewController() {
        let coordinator = CalculatorCoordinator(navigationController: navigationController)
        children.removeAll()
        coordinator.parentCoordinator = self
        children.append(coordinator)
        coordinator.start()
    }
    
    func showCalendarViewController() {
        let coordinator = CalendarCoordinator(navigationController: navigationController)
        children.removeAll()
        coordinator.parentCoordinator = self
        children.append(coordinator)
        coordinator.start()
    }
}

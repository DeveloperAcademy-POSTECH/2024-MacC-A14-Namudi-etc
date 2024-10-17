//
//  MainCoordinator.swift
//  CoordinatorPractice-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = MainViewReactor(coordinator: self)
        let vc = MainViewController()
        vc.reactor = reactor
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCalculatorFlow() {
        let coordinator = CalculatorCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showCalendarFlow() {
        let coordinator = CalendarCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showManagementFlow() {
        let coordinator = ManagementCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showExpenseInputFlow() {
        // TODO: - 실제 지출 및 입력 뷰 설정
    }
}

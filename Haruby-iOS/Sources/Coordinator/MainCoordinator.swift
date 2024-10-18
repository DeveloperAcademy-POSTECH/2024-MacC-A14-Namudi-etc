//
//  MainCoordinator.swift
//  CoordinatorPractice-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

final class MainCoordinator: BaseCoordinator {
    override func start() {
        let reactor = MainViewReactor()
        let vc = MainViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCalculatorFlow(salaryBudget: SalaryBudget) {
        let coordinator = CalculatorCoordinator(
            navigationController: navigationController, salaryBudget: salaryBudget)
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
    
    func showExpenseInputFlow(dailyBudget: DailyBudget) {
        // TODO: 1. 실제 지출 및 입력 뷰 설정
        // TODO: 2. 코디네이터에서 리액터에 데이터 전달하기
    }
}

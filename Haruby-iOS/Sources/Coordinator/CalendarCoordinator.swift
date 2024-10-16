//
//  HarubyCalendarCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit

class CalendarCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Parents: \(String(describing: parentCoordinator))")
        let reactor = CalendarViewReactor(coordinator: self)
        let vc = CalendarViewController()
        vc.reactor = reactor
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSpendingInput() {
        
    }
}

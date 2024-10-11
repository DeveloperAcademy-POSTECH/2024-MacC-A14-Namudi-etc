//
//  HarubyCalendarCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit

class HarubyCalendarCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Parents: \(String(describing: parentCoordinator))")
        let vc = HarubyCalendarViewController(reactor: HarubyCalendarReactor(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSpendingInput() {
        let vc = SpendingInputViewController(reactor: SpendingInputReactor())
        navigationController.pushViewController(vc, animated: true)
    }
}

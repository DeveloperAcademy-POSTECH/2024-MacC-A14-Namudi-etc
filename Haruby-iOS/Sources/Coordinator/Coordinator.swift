//
//  Coordinator.swift
//  CoordinatorPractice-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func finish() {
        childCoordinators.forEach { $0.finish() }
        childCoordinators.removeAll()
        parentCoordinator?.removeChildCoordinator(self)
    }
}

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

extension Coordinator {
    func logCoordinatorHierarchy() {
        print("Current Coordinator: \(type(of: self))")
        print("Child Coordinators:")
        for (index, coordinator) in childCoordinators.enumerated() {
            print("  \(index + 1). \(type(of: coordinator))")
        }
        print("Parent Coordinator: \(String(describing: type(of: parentCoordinator)))")
        print("----------------------------------------")
    }
}

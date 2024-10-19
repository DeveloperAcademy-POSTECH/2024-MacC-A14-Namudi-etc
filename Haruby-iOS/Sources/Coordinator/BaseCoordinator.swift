//
//  BaseCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/17/24.
//

import UIKit

class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("start() method must be implemented by subclass")
    }
    
    func finish() {
        childCoordinators.forEach { $0.finish() }
        childCoordinators.removeAll()
        parentCoordinator?.removeChildCoordinator(self)
    }
}

protocol CoordinatorCompatible: AnyObject {
    associatedtype CoordinatorType: Coordinator
    var coordinator: CoordinatorType? { get set }
    var didFinish: (() -> Void)? { get set }
}

extension CoordinatorCompatible where Self: UIViewController {
    func setupCoordinator() {
        didFinish = { [weak self] in
            self?.coordinator?.finish()
        }
    }
}

//
//  BaseCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/17/24.
//

import UIKit

class BaseCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("start() method must be implemented by subclass")
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

//
//  HarubyCalculatorCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit

final class CalculatorCoordinator: BaseCoordinator {
    override func start() {
        let reactor = CalculatorViewReactor()
        let vc = CalculatorViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

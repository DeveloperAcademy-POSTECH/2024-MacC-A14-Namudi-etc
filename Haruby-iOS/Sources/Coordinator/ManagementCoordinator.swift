//
//  HarubyManagementCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit

final class ManagementCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: - 하루비 관리 뷰 설정
    }
    
    func showFixedIncomeManagement() {
        // TODO: - 고정 수입 관리 뷰 설정
    }
    
    func showFixedExpenseManagement() {
        // TODO: - 고정 지출 관리 뷰 설정
    }
}


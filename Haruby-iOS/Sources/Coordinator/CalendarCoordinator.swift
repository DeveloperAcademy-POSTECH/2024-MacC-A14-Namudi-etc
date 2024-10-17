//
//  HarubyCalendarCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit

final class CalendarCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = CalendarViewReactor(coordinator: self)
        let vc = CalendarViewController()
        vc.reactor = reactor
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showHarubyEditFlow() {
        // TODO: - 하루비 수정 뷰 설정
    }
    
    func showExpenseEditFlow() {
        // TODO: - 실제 지출 입력 뷰 설정
    }
    
    func presentEditSheet() {
        // TODO: - 하루비 수정과 실제 지출을 분기하는 시트 설정
    }
}

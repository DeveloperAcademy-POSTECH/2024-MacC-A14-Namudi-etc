//
//  CalendarCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

class CalendarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        print("calendar coordinator start")
        let vc = CalendarViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("calendar coordinator deinit")
    }
    
    func showCalendarDetailView() {
        let vc = CalendarDetailViewController(coordinator: self)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        navigationController.present(vc, animated: true)
    }
}

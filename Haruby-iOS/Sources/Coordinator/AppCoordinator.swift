//
//  AppCoordinator.swift
//  CoordinatorPractice-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    override func start() {
        updateNavigationBarColor()
        showMain()
    }
    
    func updateNavigationBarColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.Haruby.white
        ]
        
        appearance.titleTextAttributes = textAttributes
        appearance.largeTitleTextAttributes = textAttributes
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        
        navigationController.navigationBar.tintColor = .Haruby.white
        navigationController.navigationBar.isTranslucent = true
    }
    
    func showMain() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
    }
}

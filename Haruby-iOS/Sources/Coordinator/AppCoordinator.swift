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
        showOnboarding()
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
    
    func showOnboarding() {
        let coordinator = OnboardingCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func onboardingDidFinish() {
        childCoordinators.removeAll { $0 is OnboardingCoordinator }
        navigationController.setNavigationBarHidden(false, animated: true)
        showMain()
    }
    
    func showMain() {
        navigationController.viewControllers.removeAll()
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}

//
//  OnboardingCoordinator.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/19/24.
//

import Foundation

final class OnboardingCoordinator: BaseCoordinator {
    override func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        showFirstOnboarding()
    }
    
    func showFirstOnboarding() {
        let reactor = FirstOnboardingReactor()
        let vc = FirstOnboardingViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSecondOnboarding() {
        let reactor = SecondOnboardingReactor()
        let vc = SecondOnboardingViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showThirdOnboarding() {
        let reactor = ThirdOnboardingReactor()
        let vc = ThirdOnboardingViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFourthOnboarding() {
        let reactor = FourthOnboardingReactor()
        let vc = FourthOnboardingViewController()
        vc.reactor = reactor
        vc.coordinator = self
        vc.didFinish = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func finish() {
        super.finish()
        // AppCoordinator에 온보딩이 완료되었음을 알림
        if let appCoordinator = parentCoordinator as? AppCoordinator {
            appCoordinator.onboardingDidFinish()
        }
    }
}

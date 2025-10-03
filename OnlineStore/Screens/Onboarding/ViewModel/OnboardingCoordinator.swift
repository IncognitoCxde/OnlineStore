//
//  OnboardingCoordinator.swift
//  OnlineStore
//
//  Created by Aziza Azizova on 03/10/25.
//

import UIKit

final class OnboardingCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.onFinish = { [weak self] in
            self?.showMain()
        }
        navigationController.setViewControllers([onboardingVC], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showMain() {
        //открываем таббар
        let mainTabBar = TabBarController()
        navigationController.setViewControllers([mainTabBar], animated: true)
    }
}

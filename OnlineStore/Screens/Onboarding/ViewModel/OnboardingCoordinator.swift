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
            // Сохраняем флаг, что онбординг завершён
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            self?.showSignIn()
        }
        navigationController.setViewControllers([onboardingVC], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showSignIn() {
        let signInVC = SignInViewController()
        navigationController.setViewControllers([signInVC], animated: true)
    }
}

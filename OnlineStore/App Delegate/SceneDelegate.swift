//
//  SceneDelegate.swift
//  OnlineStore
//
//  Created by iMacbook on 9/27/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var onboardingCoordinator: OnboardingCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // временно сбрасываем
        //UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

        if hasSeenOnboarding {
            // Показываем основной интерфейс
            let mainTabBar = TabBarController()
            window.rootViewController = mainTabBar
        } else {
            // Показываем онбординг
            onboardingCoordinator = OnboardingCoordinator(window: window)
            onboardingCoordinator?.start()
        }

        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
     
    }


}


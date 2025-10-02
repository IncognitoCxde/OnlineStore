//
//  TabBarController.swift
//  OnlineStore
//
//  Created by iMacbook on 9/27/25.
//

import UIKit
import DesignSystem

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    func setUpTabBar() {
        let tabBar = UITabBar()
        setValue(tabBar, forKey: "tabBar")
        
        
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Home", image: AppIcons.home.withRenderingMode(.alwaysOriginal), selectedImage: AppIcons.homeActive.withRenderingMode(.alwaysOriginal))
        
        let wishVC = WishlistViewController()
        wishVC.tabBarItem = UITabBarItem(title: "Wishlist", image: AppIcons.heart.withRenderingMode(.alwaysOriginal), selectedImage: AppIcons.heartActive.withRenderingMode(.alwaysOriginal))
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: AppIcons.search.withRenderingMode(.alwaysOriginal), selectedImage: AppIcons.searchActive.withRenderingMode(.alwaysOriginal))
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: AppIcons.profile.withRenderingMode(.alwaysOriginal), selectedImage: AppIcons.profileActive.withRenderingMode(.alwaysOriginal))
        
        self.setViewControllers([mainVC, wishVC, searchVC, profileVC], animated: true)
        
    }

}

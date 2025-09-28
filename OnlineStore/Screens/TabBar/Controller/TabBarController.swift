//
//  TabBarController.swift
//  OnlineStore
//
//  Created by iMacbook on 9/27/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    func setUpTabBar() {
        let tabBar = UITabBar()
        setValue(tabBar, forKey: "tabBar")
        
        
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage.home.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.homeActive.withRenderingMode(.alwaysOriginal))
        
        let wishVC = WishlistViewController()
        wishVC.tabBarItem = UITabBarItem(title: "Wishlist", image: UIImage.heart.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.heartActive.withRenderingMode(.alwaysOriginal))
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage.search.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.searchActive.withRenderingMode(.alwaysOriginal))
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage.profile.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.profileActive.withRenderingMode(.alwaysOriginal))
        
        self.setViewControllers([mainVC, wishVC, searchVC, profileVC], animated: true)
        
    }

}

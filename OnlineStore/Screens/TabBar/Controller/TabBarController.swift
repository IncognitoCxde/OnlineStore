// TabBar Controller

import UIKit
import DesignSystem

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    func setUpTabBar() {
        let tabBar = UITabBar()
        tabBar.backgroundColor = .white
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let itemOffset: CGFloat = 15
        
        var tabBarFrame = tabBar.frame
        
        tabBarFrame.origin.y -= itemOffset / 2
        tabBarFrame.size.height += itemOffset
        tabBar.frame = tabBarFrame
        
        for tabBarSubView in tabBar.subviews {
            if let tabBarButton = tabBarSubView as? UIControl {
                var frame = tabBarButton.frame
                frame.origin.y += itemOffset / 2
                tabBarButton.frame = frame
            }
        }
    }

}

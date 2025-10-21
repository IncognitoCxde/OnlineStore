import UIKit
import DesignSystem

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        rebuildTabs()
    }

    func rebuildTabs() {
        let tabBar = UITabBar()
        tabBar.backgroundColor = .white
        setValue(tabBar, forKey: "tabBar")

        var viewControllers: [UIViewController] = []

        // 1. Home
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: AppIcons.home.withRenderingMode(.alwaysOriginal),
            selectedImage: AppIcons.homeActive.withRenderingMode(.alwaysOriginal)
        )
        viewControllers.append(mainVC)

        // 2. Wishlist
        let wishVC = WishlistViewController()
        wishVC.tabBarItem = UITabBarItem(
            title: "Wishlist",
            image: AppIcons.heart.withRenderingMode(.alwaysOriginal),
            selectedImage: AppIcons.heartActive.withRenderingMode(.alwaysOriginal)
        )
        viewControllers.append(wishVC)

        // Если менеджер → вставляем Manager на 3‑ю позицию
        if UserSession.shared.accountType == .manager {
            let managerVC = ManagerDashboardViewController()
            managerVC.tabBarItem = UITabBarItem(
                title: "Manager",
                image: AppIcons.manager.withRenderingMode(.alwaysOriginal),
                selectedImage: AppIcons.manager.withRenderingMode(.alwaysOriginal)
            )
            viewControllers.append(managerVC)
        }

        // Search всегда после Wishlist/Manager
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(
            title: "Search",
            image: AppIcons.search.withRenderingMode(.alwaysOriginal),
            selectedImage: AppIcons.searchActive.withRenderingMode(.alwaysOriginal)
        )
        viewControllers.append(searchVC)

        // Profile всегда последним
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: AppIcons.profile.withRenderingMode(.alwaysOriginal),
            selectedImage: AppIcons.profileActive.withRenderingMode(.alwaysOriginal)
        )
        viewControllers.append(profileVC)

        setViewControllers(viewControllers, animated: false)

        // Автопереход на менеджерскую вкладку, если нужно
        if UserSession.shared.accountType == .manager {
            selectedIndex = 2
        }
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

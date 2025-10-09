// CartViewController - Benazir Manuchehri

import UIKit
import DesignSystem

class CartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setupCustomBackButton()
    }
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        let icon = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(icon, for: .normal)
        backButton.tintColor = AppColors.arsenicDark
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

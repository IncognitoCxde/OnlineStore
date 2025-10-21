//  Update Category ViewController - BM

import UIKit
import DesignSystem

final class UpdateCategoryViewController: UIViewController {
    
    // MARK: - Variables
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage.arrow
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUp()
    }
    
    // MARK: - Set Up
    
    func setUp() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        configureConstraints()
    }
    
    // MARK: - Configure Constraints
    
    func configureConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true)
    }
}

//  CartViewController

import UIKit
import DesignSystem

class CartViewController: UIViewController {
    
    let titleLabel = UILabel()
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUp()
    }
    
    func setUp() {
        setUpTitleLabel()
        setUpBackButton()
        setUpConstraints()
    }
    
    func setUpBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.textColor = AppColors.arsenicDark
        titleLabel.font = AppFont.semiBold_18pt(size: 19)
        titleLabel.textAlignment = .center
        titleLabel.text = "Cart"
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true)
    }

}

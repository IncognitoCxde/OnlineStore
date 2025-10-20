//  CartViewController

// MARK: - Imports

import UIKit
import DesignSystem

class CartViewController: UIViewController {
    
    // MARK: - Variables
    
    let viewModel = CartViewModel()
    
    let titleLabel = UILabel()
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let tableView = UITableView()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUp()
    }
    
    // MARK: - Set up Nav
    
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
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

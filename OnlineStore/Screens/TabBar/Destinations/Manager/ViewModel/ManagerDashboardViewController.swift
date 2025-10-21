// Manager Dashboard VC - BM

// MARK: - Imports

import UIKit
import SnapKit
import DesignSystem

final class ManagerDashboardViewController: UIViewController {
    
    // MARK: - Variables
    
    private let productsTitleLabel = UILabel()
    private let productsUnderline = UIView()
    private let createProductButton = UIButton.createManagerButton(title: "Create Product")
    private let updateProductButton = UIButton.createManagerButton(title: "Update Product")
    
    private let categoriesTitleLabel = UILabel()
    private let categoriesUnderline = UIView()
    private let createCategoryButton = UIButton.createManagerButton(title: "Create Category")
    private let updateCategoryButton = UIButton.createManagerButton(title: "Update Category")
    
    private let managerTitle: UILabel = {
        let label = UILabel()
        label.text = "Manager Dashboard"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.semiBold_18pt(size: 19)
        return label
    }()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        setUpActions()
    }
}

// MARK: - Setup UI

private extension ManagerDashboardViewController {
    
    // MARK: - Details
    
    func setupUI() {
        view.addSubview(managerTitle)
        
        productsTitleLabel.text = "Products"
        productsTitleLabel.font = AppFont.medium_18pt(size: 18)
        productsTitleLabel.textAlignment = .left
        view.addSubview(productsTitleLabel)
        
        productsUnderline.backgroundColor = AppColors.mediumGrey
        view.addSubview(productsUnderline)
        
        view.addSubview(createProductButton)
        view.addSubview(updateProductButton)
        
        categoriesTitleLabel.text = "Categories"
        categoriesTitleLabel.font = AppFont.medium_18pt(size: 18)
        categoriesTitleLabel.textAlignment = .left
        view.addSubview(categoriesTitleLabel)
        
        categoriesUnderline.backgroundColor = AppColors.mediumGrey
        view.addSubview(categoriesUnderline)
        
        view.addSubview(createCategoryButton)
        view.addSubview(updateCategoryButton)
    }
    
    // MARK: - Constraints
    
    func setupConstraints() {
        managerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        productsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(170)
            make.leading.equalToSuperview().offset(40)
        }
        
        productsUnderline.snp.makeConstraints { make in
            make.top.equalTo(productsTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(1)
        }
        
        createProductButton.snp.makeConstraints { make in
            make.top.equalTo(productsUnderline.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        updateProductButton.snp.makeConstraints { make in
            make.top.equalTo(createProductButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(createProductButton)
        }
        
        categoriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(updateProductButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(40)
        }
        
        categoriesUnderline.snp.makeConstraints { make in
            make.top.equalTo(categoriesTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(1)
        }
        
        createCategoryButton.snp.makeConstraints { make in
            make.top.equalTo(categoriesUnderline.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        updateCategoryButton.snp.makeConstraints { make in
            make.top.equalTo(createCategoryButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(createCategoryButton)
        }
    }
    
    // MARK: - Set up Actions & objc funcs
    
    func setUpActions() {
        createProductButton.addTarget(self, action: #selector(openCreateProduct), for: .touchUpInside)
        updateProductButton.addTarget(self, action: #selector(openUpdateProduct), for: .touchUpInside)
        createCategoryButton.addTarget(self, action: #selector(openCreateCategory), for: .touchUpInside)
        updateCategoryButton.addTarget(self, action: #selector(openUpdateCategory), for: .touchUpInside)
    }
    
    @objc private func openCreateProduct() {
        let createProductVC = CreateProductViewController()
        createProductVC.modalPresentationStyle = .fullScreen
        present(createProductVC, animated: true)
    }

    @objc private func openUpdateProduct() {
        let updateProductVC = UpdateProductViewController()
        updateProductVC.modalPresentationStyle = .fullScreen
        present(updateProductVC, animated: true)
    }

    @objc private func openCreateCategory() {
        let createCategoryVC = CreateCategoryViewController()
        createCategoryVC.modalPresentationStyle = .fullScreen
        present(createCategoryVC, animated: true)
    }

    @objc private func openUpdateCategory() {
        let updateCategoryVC = UpdateCategoryViewController()
        updateCategoryVC.modalPresentationStyle = .fullScreen
        present(updateCategoryVC, animated: true)
    }


}

// MARK: - Custom Blue Btn. Ext.

private extension UIButton {
    static func createManagerButton(title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = AppColors.customBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.medium_18pt(size: 16)
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        return button
    }
}

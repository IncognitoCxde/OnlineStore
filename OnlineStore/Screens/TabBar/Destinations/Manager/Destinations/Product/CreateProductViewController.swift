//  Create Product ViewController for Manager VC - BM

// MARK: - Imports

import UIKit
import DesignSystem
import SnapKit

final class CreateProductViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage.arrow
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let screenTitle: UILabel = {
        let label = UILabel()
        label.text = "Create a Product"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.bold_18pt(size: 18)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.bold_18pt(size: 16)
        return label
    }()
    
    private let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter product title"
        field.font = AppFont.bold_18pt(size: 16)
        field.backgroundColor = .white
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 0.5
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.setLeftPaddingPoints(10)
        return field
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.bold_18pt(size: 16)
        return label
    }()
    
    private let priceField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter product price"
        field.font = AppFont.bold_18pt(size: 16)
        field.backgroundColor = .white
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 0.5
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.keyboardType = .decimalPad
        field.setLeftPaddingPoints(10)
        return field
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.bold_18pt(size: 16)
        return label
    }()
    
    private let categoryContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let categoryLabelValue: UILabel = {
        let label = UILabel()
        label.text = "Select category"
        label.font = AppFont.bold_18pt(size: 16)
        label.textColor = AppColors.grey
        return label
    }()
    
    private let dropdownIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "chevron.down"))
        icon.tintColor = AppColors.mediumGrey
        return icon
    }()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.lighterGrey.cgColor
        return tableView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.bold_18pt(size: 16)
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = AppFont.bold_18pt(size: 16)
        return textView
    }()
    
    private let imageLabel: UILabel = {
        let label = UILabel()
        label.text = "Images"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.bold_18pt(size: 16)
        return label
    }()
    
    private let imageField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter image URL"
        field.font = AppFont.bold_18pt(size: 16)
        field.backgroundColor = .white
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 0.5
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.setLeftPaddingPoints(10)
        return field
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = AppColors.customBlue
        button.titleLabel?.font = AppFont.medium_18pt(size: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: - Data
    
    private var isDropdownVisible = false
    private let categories = ["Clothes", "Electronics", "Furniture", "Miscellaneous", "Shoes"]
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUpUI()
        configureConstraints()
        setUpActions()
    }
}

// MARK: - Setup UI

private extension CreateProductViewController {
    // MARK: - Details
    
    func setUpUI() {
        view.addSubviews(backButton, screenTitle, titleLabel, titleField,
                         priceLabel, priceField, categoryLabel, categoryContainer,
                         categoryTableView, descriptionLabel, descriptionTextView,
                         imageLabel, imageField, saveButton)
        
        
        categoryContainer.addSubviews(categoryLabelValue, dropdownIcon)
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    
    func configureConstraints() {
        let padding: CGFloat = 20
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.leading.equalToSuperview().inset(padding)
        }
        
        screenTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(screenTitle.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        titleField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(45)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        priceField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(45)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(priceField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        categoryContainer.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(45)
        }
        
        categoryLabelValue.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        dropdownIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryContainer.snp.bottom).offset(4)
            make.leading.trailing.equalTo(categoryContainer)
            make.height.equalTo(0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTableView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(100)
        }
        
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        imageField.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(45)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(imageField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(50)
        }
    }
    
    func setUpActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        categoryContainer.addGestureRecognizer(tap)
    }
}

// MARK: - Actions

private extension CreateProductViewController {
    @objc func handleBackButton() {
        self.dismiss(animated: true)
    }
    
    @objc func toggleDropdown() {
        isDropdownVisible.toggle()
        categoryTableView.isHidden = !isDropdownVisible
        categoryTableView.snp.updateConstraints { make in
            make.height.equalTo(isDropdownVisible ? CGFloat(categories.count * 44) : 0)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableView Delegate & DataSource

extension CreateProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.font = AppFont.regular18pt(size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryLabelValue.text = categories[indexPath.row]
        toggleDropdown()
    }
}

// MARK: - Padding Helper

private extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}

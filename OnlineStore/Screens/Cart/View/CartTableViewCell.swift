//  CartTableViewCell

// MARK: - Imports

import UIKit
import SnapKit
import DesignSystem

// MARK: - Protocol

protocol CartTableViewCellDelegate: AnyObject {
    func didTapTrash(for item: CartItem)
    func didChangeQuantity(for item: CartItem, to quantity: Int)
    func didToggleSelection(for item: CartItem)
}

final class CartTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: CartTableViewCell.self)
    weak var delegate: CartTableViewCellDelegate?
    
    var item: CartItem?
    
    var quantity: Int = 1
    
    var isChecked = true {
        didSet {
            updateCheckbox()
        }
    }
    
    // MARK: - UI Elements
    
    let containerView = UIView()
    let productImageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    let checkboxButton = UIButton(type: .system)
    let minusButton = UIButton(type: .system)
    let plusButton = UIButton(type: .system)
    var quantityLabel = UILabel()
    let trashButton = UIButton(type: .system)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupActions()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up UI
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = AppColors.arsenicDark.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(containerView)
        
        updateCheckbox()
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        titleLabel.font = AppFont.semiBold_18pt(size: 16)
        titleLabel.textColor = AppColors.arsenicDark
        
        
        priceLabel.font = AppFont.semiBold_18pt(size: 19)
        priceLabel.textColor = AppColors.arsenicDark
        
        minusButton.setImage(AppIcons.remove, for: .normal)
        minusButton.tintColor = AppColors.grey
        plusButton.setImage(AppIcons.add, for: .normal)
        plusButton.tintColor = AppColors.grey
        trashButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        trashButton.tintColor = AppColors.grey
        
        quantityLabel.font = AppFont.regular18pt(size: 16)
        quantityLabel.textColor = AppColors.grey
        quantityLabel.textAlignment = .center
        
        [checkboxButton, productImageView, titleLabel, priceLabel,
         minusButton, plusButton, quantityLabel, trashButton].forEach {
            containerView.addSubview($0)
        }
        
    }
    
    // MARK: - Constraints
    
    func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        checkboxButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(productImageView)
            make.size.equalTo(24)
        }
        
        productImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(checkboxButton.snp.right).offset(12)
            make.width.height.equalTo(80)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView).inset(5)
            make.left.equalTo(productImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
        }
        
        trashButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(priceLabel)
            make.size.equalTo(24)
        }
        
        plusButton.snp.makeConstraints { make in
            make.right.equalTo(trashButton.snp.left).offset(-12)
            make.centerY.equalTo(trashButton)
            make.size.equalTo(24)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.right.equalTo(plusButton.snp.left).offset(-4)
            make.centerY.equalTo(plusButton)
            make.width.equalTo(24)
        }
        
        minusButton.snp.makeConstraints { make in
            make.right.equalTo(quantityLabel.snp.left).offset(-4)
            make.centerY.equalTo(plusButton)
            make.size.equalTo(24)
        }
    }
    
    // MARK: - Set Up Actions
    
    func setupActions() {
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        trashButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
}

extension CartTableViewCell {
    
    // MARK: - Configuration
    
    func configure(with item: CartItem) {
        self.item = item
        productImageView.setImage(from: item.imageName)
        titleLabel.text = item.name
        titleLabel.font = AppFont.medium_18pt(size: 16)
        priceLabel.text = CurrencyManager.shared.convert(priceInUSD: item.totalPrice)
        quantity = item.quantity
        quantityLabel.text = "\(quantity)"
        isChecked = item.isSelected
    }
    
    @objc func toggleCheckbox() {
        isChecked.toggle()
        item?.isSelected = isChecked
        delegate?.didToggleSelection(for: item!)
    }
    
    @objc func increaseQuantity() {
        quantity += 1
        item?.quantity = quantity
        delegate?.didChangeQuantity(for: item!, to: quantity)
    }
    
    @objc func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
            item?.quantity = quantity
            delegate?.didChangeQuantity(for: item!, to: quantity)
        }
    }
    
    @objc func deleteTapped() {
        delegate?.didTapTrash(for: item ?? itemDefault)
    }
    
    func updateCheckbox() {
        if isChecked {
            checkboxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            checkboxButton.tintColor = AppColors.customBlue
        } else {
            checkboxButton.backgroundColor = .clear
            checkboxButton.setImage(nil, for: .normal)
        }
    }
}

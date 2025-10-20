//  CartTableViewCell

// MARK: - Imports

import UIKit
import SnapKit
import DesignSystem

// MARK: - Protocol

protocol CartTableViewCellDelegate: AnyObject {
    func didTapTrash(for cell: CartTableViewCell)
    func didChangeQuantity(for cell: CartTableViewCell, to quantity: Int)
}

final class CartTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CartTableViewCell"
    weak var delegate: CartTableViewCellDelegate?
    
    private var quantity: Int = 1 {
        didSet {
            quantityLabel.text = "\(quantity)"
            delegate?.didChangeQuantity(for: self, to: quantity)
        }
    }
    
    private var isChecked = false {
        didSet {
            updateCheckbox()
        }
    }
    
    // MARK: - UI Elements
    
    private let containerView = UIView()
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let checkboxButton = UIButton(type: .system)
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let quantityLabel = UILabel()
    private let trashButton = UIButton(type: .system)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

private extension CartTableViewCell {
    
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
        
        checkboxButton.layer.cornerRadius = 6
        checkboxButton.layer.borderWidth = 1
        checkboxButton.layer.borderColor = UIColor.systemGray3.cgColor
        updateCheckbox()
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        titleLabel.font = AppFont.semiBold_18pt(size: 16)
        titleLabel.textColor = AppColors.arsenicDark
        
        
        priceLabel.font = AppFont.semiBold_18pt(size: 18)
        priceLabel.textColor = AppColors.arsenicDark
        
        minusButton.setImage(AppIcons.remove, for: .normal)
        plusButton.setImage(AppIcons.add, for: .normal)
        trashButton.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        
        quantityLabel.text = "1"
        quantityLabel.font = AppFont.regular18pt(size: 16)
        quantityLabel.textColor = AppColors.arsenicDark
        quantityLabel.textAlignment = .center
        
        [checkboxButton, productImageView, titleLabel, priceLabel,
         minusButton, plusButton, quantityLabel, trashButton].forEach {
            containerView.addSubview($0)
        }
        
    }
    
    // MARK: - Constraints
    
    func setUpConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalTo(productImageView)
            $0.size.equalTo(24)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalTo(checkboxButton.snp.right).offset(12)
            $0.width.height.equalTo(80)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView)
            $0.left.equalTo(productImageView.snp.right).offset(12)
            $0.right.equalToSuperview().offset(-12)
        }
        
        
        priceLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
        }
        
        trashButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.bottom.equalTo(priceLabel)
            $0.size.equalTo(24)
        }
        
        plusButton.snp.makeConstraints {
            $0.right.equalTo(trashButton.snp.left).offset(-12)
            $0.centerY.equalTo(trashButton)
            $0.size.equalTo(24)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.right.equalTo(plusButton.snp.left).offset(-4)
            $0.centerY.equalTo(plusButton)
            $0.width.equalTo(24)
        }
        
        minusButton.snp.makeConstraints {
            $0.right.equalTo(quantityLabel.snp.left).offset(-4)
            $0.centerY.equalTo(plusButton)
            $0.size.equalTo(24)
        }
    }
    
    func setupActions() {
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        trashButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
}

// MARK: - Actions

private extension CartTableViewCell {
    
    @objc func toggleCheckbox() {
        isChecked.toggle()
    }
    
    @objc func increaseQuantity() {
        quantity += 1
    }
    
    @objc func decreaseQuantity() {
        if quantity > 1 { quantity -= 1 }
    }
    
    @objc func deleteTapped() {
        delegate?.didTapTrash(for: self)
    }
    
    func updateCheckbox() {
        if isChecked {
            checkboxButton.backgroundColor = AppColors.customBlue
            checkboxButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checkboxButton.tintColor = .white
        } else {
            checkboxButton.backgroundColor = .clear
            checkboxButton.setImage(nil, for: .normal)
        }
    }
}

// MARK: - Configuration

extension CartTableViewCell {
    func configure(with product: ProductInfo) {
        productImageView.image = UIImage(named: product.images?.first ?? "")
        titleLabel.text = product.title
        priceLabel.text = "$ \(String(format: "%.2f", product.price ?? 0))"
    }
}

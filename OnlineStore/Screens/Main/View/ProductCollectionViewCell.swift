//
//  ProductCollectionViewCell


import UIKit
import SnapKit
import DesignSystem

public class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    public static let identifier = String(describing: ProductCollectionViewCell.self)
    
    // MARK: - Variables
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBackground()
        setUpUIDetails()
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpBackground()
        setUpUIDetails()
        setupUI()
    }
    
    // MARK: - UI
    
    private func setUpBackground() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = AppColors.arsenicDark.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setUpUIDetails() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        titleLabel.font = AppFont.regular18pt(size: 14)
        titleLabel.textColor = AppColors.arsenicDark
        
        priceLabel.font = AppFont.semiBold_18pt(size: 18)
        priceLabel.textColor = AppColors.arsenicDark
        
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.titleLabel?.font = AppFont.regular18pt(size: 14)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = AppColors.customBlue
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
    }
    
    private func setupUI() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
                
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(imageView).inset(10)
            make.height.equalTo(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(20)
        }
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
//            make.height.equalTo(25)
        }
    }
    
    // MARK: - Configure
    
    public func configure(with product: Product) {
        if (product.images?.first) != nil {
            imageView.setImage(from: product.images?.first)
        } else {
            imageView.image = UIImage(named: "Headphones")
        }

        titleLabel.text = product.title ?? "Product"
        priceLabel.text = CurrencyManager.shared.convert(priceInUSD: product.price ?? 0)

    }
    
    @objc func handleAddToCart() {
        print("Product added to cart!")
    }
}

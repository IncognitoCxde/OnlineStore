import UIKit
import SnapKit
import DesignSystem

class WishlistCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let buttonContainer = UIStackView()
    private let heartButton = UIButton()
    private let addToCartButton = UIButton()

    private var product: ProductInfo?
    private var isAddedToCart = false

    var onHeartTapped: ((ProductInfo) -> Void)?
    var onAddToCartTapped: ((ProductInfo) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with product: ProductInfo) {
        self.product = product
        isAddedToCart = false

        imageView.setImage(from: product.images?.first)
        titleLabel.text = product.title ?? "No title"
        priceLabel.text = CurrencyManager.shared.convert(priceInUSD: product.price ?? 0)

        let isFavorite = FavoritesManager.shared.isFavorite(product.id ?? -1)
        let icon = isFavorite ? AppIcons.heartActive : AppIcons.heart
        heartButton.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
        heartButton.tintColor = isFavorite ? AppColors.customBlue : AppColors.grey

        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.backgroundColor = AppColors.customBlue
    }

    private func setupActions() {
        heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
    }

    @objc private func heartTapped() {
        guard let product = product else { return }
        onHeartTapped?(product)
    }

    @objc private func addToCartTapped() {
        
        guard let product = product else { return }
        guard !isAddedToCart else { return }
        
        let newItem = CartItem(
            id: UUID(),
            name: product.title ?? "Unknown Product",
            imageName: product.images?.first ?? "",
            price: product.price ?? 0,
            quantity: 1,
            isSelected: true
        )
        
        CartManager.shared.addItem(newItem)

        onAddToCartTapped?(product)

        isAddedToCart = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        UIView.transition(with: addToCartButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.addToCartButton.setTitle("Added", for: .normal)
            self.addToCartButton.backgroundColor = AppColors.lightBlue
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isAddedToCart = false
            UIView.transition(with: self.addToCartButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.addToCartButton.setTitle("Add to cart", for: .normal)
                self.addToCartButton.backgroundColor = AppColors.customBlue
            })
        }
        
        
    }

    private func setupUI() {
        contentView.backgroundColor = AppColors.lightGrey
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = AppColors.arsenicDark.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.clipsToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        titleLabel.font = AppFont.regular18pt(size: 14)
        titleLabel.textColor = AppColors.arsenicDark
        titleLabel.numberOfLines = 2

        priceLabel.font = AppFont.semiBold_18pt(size: 18)
        priceLabel.textColor = AppColors.arsenicDark

        addToCartButton.titleLabel?.font = AppFont.regular18pt(size: 14)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = AppColors.customBlue
        addToCartButton.layer.cornerRadius = 8

        heartButton.tintColor = AppColors.grey
        heartButton.setContentHuggingPriority(.required, for: .horizontal)

        buttonContainer.axis = .horizontal
        buttonContainer.spacing = 12
        buttonContainer.alignment = .fill
        buttonContainer.distribution = .fill
        buttonContainer.addArrangedSubview(heartButton)
        buttonContainer.addArrangedSubview(addToCartButton)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(buttonContainer)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(8)
        }

        buttonContainer.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(36)
        }

        heartButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
}

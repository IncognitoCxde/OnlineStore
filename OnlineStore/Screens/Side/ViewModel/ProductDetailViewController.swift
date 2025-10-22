import UIKit
import SnapKit
import DesignSystem

class ProductDetailViewController: UIViewController {
    
    // MARK: - Variables
    
    let screenTitle = UILabel()
    let cartButton: UIButton = {
        let button = UIButton()
        let image = AppIcons.cart
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let productInfo: ProductInfo
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionTitle = UILabel()
    private let descriptionLabel = UILabel()
    
    private let buyNowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Buy Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.medium_18pt(size: 18)
        button.backgroundColor = AppColors.customBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let addToCart: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = AppFont.medium_18pt(size: 18)
        button.setTitleColor(AppColors.arsenicDark, for: .normal)
        button.backgroundColor = .lighterGrey
        button.layer.borderColor = AppColors.grey.cgColor
        button.layer.borderWidth = 0.3
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let favoriteButton: UIButton = {
        let fav = UIButton()
        fav.tintColor = AppColors.grey
        fav.setImage(AppIcons.heart.withRenderingMode(.alwaysTemplate), for: .normal)
        return fav
    }()
    
    let favBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .lighterGrey
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Init
    
    init(productInfo: ProductInfo) {
        self.productInfo = productInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUpNav()
        setUpBackButton()
        setUpScrollView()
        addSubViews()
        setUpUI()
        setUpConstraints()
        setUpActions()
        updateFavoriteUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteUI()
    }
    
    // MARK: - Setup
    
    func setUpNav() {
        view.addSubview(screenTitle)
        screenTitle.textColor = AppColors.arsenicDark
        screenTitle.font = AppFont.medium_18pt(size: 19)
        screenTitle.textAlignment = .center
        screenTitle.text = "Product details"
        
        screenTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        
        view.addSubview(cartButton)
        cartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setUpBackButton() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - ScrollView
    
    func setUpScrollView() {
        scrollView.bouncesVertically = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bouncesHorizontally = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
    }
    
    // MARK: - AddSubViews
    
    func addSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favBackground)
        favBackground.addSubview(favoriteButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(descriptionTitle)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(addToCart)
        contentView.addSubview(buyNowButton)
        
        addToCart.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        buyNowButton.addTarget(self, action: #selector(buyNowTapped), for: .touchUpInside)
    }
    
    // MARK: - UI
    
    func setUpUI() {
        imageView.setImage(from: productInfo.images?.first)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        titleLabel.text = productInfo.title
        titleLabel.font = AppFont.semiBold_24pt(size: 22)
        titleLabel.numberOfLines = 3
        titleLabel.textColor = AppColors.arsenicDark
        
        priceLabel.text = CurrencyManager.shared.convert(priceInUSD: productInfo.price ?? 0)
        priceLabel.font = AppFont.bold_24pt(size: 25)
        priceLabel.textColor = AppColors.arsenicDark
        
        descriptionTitle.text = "Description of product"
        descriptionTitle.font = AppFont.medium_18pt(size: 19)
        descriptionTitle.textColor = AppColors.arsenicDark
        
        descriptionLabel.text = productInfo.description ?? "No Description"
        descriptionLabel.numberOfLines = 10
        descriptionLabel.font = AppFont.regular18pt(size: 16)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = AppColors.arsenicDark
    }
    
    // MARK: - Constraints
    
    func setUpConstraints() {
        imageView.snp.makeConstraints {
            $0.height.equalTo(230)
            $0.width.equalTo(380)
            $0.leading.trailing.equalTo(contentView).inset(10)
            $0.top.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(15)
            $0.leading.equalTo(imageView.snp.leading).inset(8)
            $0.trailing.equalToSuperview().inset(100)
        }
        
        favBackground.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(40)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        descriptionTitle.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(15)
            $0.leading.equalTo(priceLabel.snp.leading)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionTitle.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        buyNowButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
        
        addToCart.snp.makeConstraints {
            $0.top.equalTo(buyNowButton.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
    }
    
    func setUpActions() {
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    // MARK: - Favorite Logic
    
    @objc func favoriteTapped() {
        guard let id = productInfo.id else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(id)

        if isFavorite {
            FavoritesManager.shared.remove(id)
        } else {
            FavoritesManager.shared.add(productInfo)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }

        updateFavoriteUI()

        UIView.animate(withDuration: 0.2,
                       animations: {
                           self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                       },
                       completion: { _ in
                           UIView.animate(withDuration: 0.2) {
                               self.favoriteButton.transform = .identity
                           }
                       })
    }

    private func updateFavoriteUI() {
        guard let id = productInfo.id else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(id)
        favoriteButton.tintColor = isFavorite ? AppColors.customBlue : AppColors.grey
        let icon = isFavorite ? AppIcons.heartActive : AppIcons.heart
        favoriteButton.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    
    // MARK: - Handle Back Tap
    @objc func handleBackButton() {
        self.dismiss(animated: true)
        
    }
    
    // MARK: - Handle Buy Now
    
    @objc func buyNowTapped() {
        
    }
    
    // MARK: - Handle Add to Cart
    @objc func addToCartTapped() {
        
        let newItem = CartItem(
            id: UUID(),
            name: productInfo.title ?? "Unknown Product",
            imageName: productInfo.images?.first ?? "",
            price: productInfo.price ?? 0,
            quantity: 1,
            isSelected: true
        )
        
        CartManager.shared.addItem(newItem)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let originalTitle = addToCart.title(for: .normal)
        UIView.animate(withDuration: 0.12,
                       animations: {
            self.addToCart.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }, completion: { _ in
            UIView.animate(withDuration: 0.12) {
                self.addToCart.transform = .identity
            }
        })
        
        addToCart.setTitle("Added ✓", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addToCart.setTitle(originalTitle, for: .normal)
        }
    }
    
    // MARK: - Cart Button Handle
    @objc func cartButtonTapped() {
        let cartVC = CartViewController()
        cartVC.modalPresentationStyle = .fullScreen
        present(cartVC, animated: true)
    }
}

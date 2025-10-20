//  ProductDetailViewController - BM


// MARK: - Imports

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

    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUpNav()
        setUpBackButton()
        setUpScrollView()
        addSubViews()
        setUpUI()
        setUpConstraints()
    }
    
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
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        cartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Init
    init(productInfo: ProductInfo) {
        self.productInfo = productInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Back Button
    func setUpBackButton() {
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    // MARK: - Scroll
    
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
            make.top.bottom.leading.trailing.equalTo(scrollView)
        }
    }
    
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
        
        priceLabel.text = "$ \(productInfo.price ?? 0)"
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
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(230)
            make.width.equalTo(380)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.equalTo(imageView.snp.leading).inset(8)
            make.trailing.equalToSuperview().inset(100)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        favBackground.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(40)

        }
            
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
            make.leading.equalTo(priceLabel.snp.leading)
            
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(9)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        
        buyNowButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)

        }
        
        addToCart.snp.makeConstraints { make in
            make.top.equalTo(buyNowButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        
    }
    
    // MARK: - Handle Back Tap
    @objc func handleBackButton() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Handle Buy Now
    
    @objc func buyNowTapped() {
        
    }
    
    // MARK: - Handle add to cart
    @objc func addToCartTapped() {
        
    }
    
    // MARK: - Cart button handle
    
    @objc func cartButtonTapped() {
        let cartVC = CartViewController()
        cartVC.modalPresentationStyle = .fullScreen
        present(cartVC, animated: true)
    }
}

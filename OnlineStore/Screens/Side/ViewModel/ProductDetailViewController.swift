//  ProductDetailViewController

import UIKit
import SnapKit
import DesignSystem

class ProductDetailViewController: UIViewController {
    
    private let viewModel: ProductDetailViewModel
    
    // UI элементы
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let featuresStack = UIStackView()
    
    private let buyNowButton = UIButton(type: .system)
    private let addToCartButton = UIButton(type: .system)
    
    // MARK: - Init
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupNavBar()
        setupScrollView()
        setupContent()
        setupBottomButtons()
        configure()
    }
    
    // MARK: - Setup
    private func setupNavBar() {
        title = "Product details"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart"),
            style: .plain,
            target: self,
            action: #selector(cartTapped)
        )
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupContent() {
        // Image
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // Title + Price + Favorite
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center   // теперь кнопка выровнена по центру
        headerStack.distribution = .equalSpacing
        
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        priceLabel.font = .systemFont(ofSize: 22, weight: .bold)
        priceLabel.textColor = .label
        
        favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        favoriteButton.tintColor = .systemGray
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        
        headerStack.addArrangedSubview(labelsStack)
        headerStack.addArrangedSubview(favoriteButton)
        
        // Description
        descriptionTitleLabel.text = "Description of product"
        descriptionTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        // Features
        featuresStack.axis = .vertical
        featuresStack.spacing = 6
        
        // Add arranged subviews
        contentView.addArrangedSubview(productImageView)
        contentView.addArrangedSubview(headerStack)
        contentView.addArrangedSubview(descriptionTitleLabel)
        contentView.addArrangedSubview(descriptionLabel)
        contentView.addArrangedSubview(featuresStack)
    }
    
    private func setupBottomButtons() {
        let buttonsStack = UIStackView(arrangedSubviews: [buyNowButton, addToCartButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        buyNowButton.setTitle("Buy Now", for: .normal)
        buyNowButton.backgroundColor = .systemBlue
        buyNowButton.setTitleColor(.white, for: .normal)
        buyNowButton.layer.cornerRadius = 10
        
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.layer.borderWidth = 1
        addToCartButton.layer.borderColor = UIColor.systemGray4.cgColor
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.setTitleColor(.label, for: .normal)
        
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        view.addSubview(buttonsStack)
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            buttonsStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Configure
    private func configure() {
        productImageView.image = UIImage(named: viewModel.imageName)
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        descriptionLabel.text = viewModel.description
        
        viewModel.features.forEach { feature in
            let lbl = UILabel()
            lbl.text = "• \(feature)"
            lbl.font = .systemFont(ofSize: 13)
            lbl.textColor = .secondaryLabel
            featuresStack.addArrangedSubview(lbl)
        }
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cartTapped() {
        let cartVC = CartViewController() // создаём контроллер, а не ViewModel
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc private func favoriteTapped() {
        let isFav = favoriteButton.tintColor == .systemRed
        favoriteButton.tintColor = isFav ? .systemGray : .systemRed
    }
    
    @objc private func addToCartTapped() {
        print("product added to cart")
//         let product = viewModel.product
//            CartManager.shared.add(product)
//            let alert = UIAlertController(
//                title: "Added",
//                message: "\(product.title) added to cart",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
        }
    
}

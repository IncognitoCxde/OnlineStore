// Main VC - BM

// MARK: - Imports

import UIKit
import DesignSystem
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Variables
    
    let viewModel = MainViewModel()
    let networkingManager: HomeNetworkingProtocol = HomeNetworkingManager()
    
    let cartButton: UIButton = {
        let cart = UIButton()
        cart.setImage(AppIcons.cart, for: .normal)
        cart.tintColor = AppColors.arsenicDark
        return cart
    }()
    
    let deliveryAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivery address"
        label.textColor = AppColors.grey
        label.font = AppFont.regular18pt(size: 13)
        return label
    }()
    
    let actualAddressPick: UIButton = {
        let button = UIButton()
        button.setTitle("Select Location", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = AppColors.arsenicDark
        button.setTitleColor(AppColors.arsenicDark, for: .normal)
        button.titleLabel?.font = AppFont.medium_18pt(size: 16)
        return button
    }()
    
    private var dropDownView: DropdownView?
    private var isDropDownVisible = false
    
    
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        tabBarController?.tabBar.dropShadow()
        setUpFunctions()
        
    }
    
    func setUpFunctions() {
        addSubViews()
        configureConstraints()
        configureTargets()
        configureCollectionConstraints()
        bindViewModel()
        restoreLocation()
    }
    
    // MARK: - AddSubViews
    
    func addSubViews() {
        view.addSubview(cartButton)
        view.addSubview(deliveryAddressLabel)
        view.addSubview(actualAddressPick)
    }
    
    func configureTargets() {
        actualAddressPick.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(showCart), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    
    func configureConstraints() {
        cartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.trailing.equalToSuperview().inset(30)
        }
        
        deliveryAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(cartButton.snp.top)
            make.leading.equalToSuperview().inset(30)
        }
        
        actualAddressPick.snp.makeConstraints { make in
            make.top.equalTo(deliveryAddressLabel.snp.bottom)
            make.leading.equalTo(deliveryAddressLabel.snp.leading)
        }
        
    }
    
    // MARK: - Data Centre
    
    func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.ultimateCollectionView.reloadData()
            }
        }
        viewModel.fetchData {
            self.ultimateCollectionView.reloadData()
        }
    }
    
    // MARK: - Compositional Layout
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionType = SectionType(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .categories:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.55),
                    heightDimension: .fractionalHeight(0.3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(200),
                    heightDimension: .absolute(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 16, bottom: -35, trailing: 16)
                
                return section
            case .products:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.48),
                    heightDimension: .absolute(240)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(410),
                    heightDimension: .absolute(230)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 15
                return section
                
            case .specials:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.9)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(0.9)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
                
                
            }
        }
    }
    
    // MARK: - CollectionView
    lazy var ultimateCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.register(SectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderReusableView.identifier)
        collectionView.register(WebCollectionViewCell.self, forCellWithReuseIdentifier: WebCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.bouncesHorizontally = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    func configureCollectionConstraints() {
        view.addSubview(ultimateCollectionView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePrices),
            name: .currencyDidChange,
            object: nil
        )
        
        ultimateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(actualAddressPick.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(40)
        }
        
    }
    
    // MARK: - Handle Location Button
    
    @objc func selectLocation() {
        if isDropDownVisible {
            hideDropdown()
        } else {
            showDropdown()
        }
    }
    
    @objc func showCart() {
        let cartVC = CartViewController()
        cartVC.modalPresentationStyle = .fullScreen
        present(cartVC, animated: true)
    }
    
    // MARK: - Show Dropdown
    
    private func showDropdown() {
        let dropdown = DropdownView(items: LocationOption.allCases)
        
        dropdown.didSelectItem = { [weak self] location in
            guard let self = self else { return }
            
            self.actualAddressPick.setTitle(location.rawValue, for: .normal)
            let currency: Currency
            switch location {
            case .taj:
                currency = .tjs
            case .usa:
                currency = .usd
            case .germany:
                currency = .eur
            case .uk:
                currency = .gbp
            case .ua:
                currency = .uah
            }
            
            CurrencyManager.shared.updateCurrency(to: currency) {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .currencyDidChange, object: currency)
                }
            }
            
            UserDefaults.standard.set(location.rawValue, forKey: "selectedLocation")
            UserDefaults.standard.set(currency.rawValue, forKey: "selectedCurrency")
            
            self.hideDropdown()
        }
        
        view.addSubview(dropdown)
        
        dropdown.snp.makeConstraints { make in
            make.top.equalTo(actualAddressPick.snp.bottom).offset(8)
            make.leading.equalTo(actualAddressPick)
            make.width.equalTo(180)
            make.height.equalTo(200)
        }
        
        dropdown.alpha = 0
        dropdown.transform = CGAffineTransform(translationX: 0, y: -10)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseOut) {
            dropdown.alpha = 1
            dropdown.transform = .identity
        }
        
        dropDownView = dropdown
        isDropDownVisible = true
    }
    
    // MARK: - Hide Dropdown
    
    private func hideDropdown() {
        guard let dropdown = dropDownView else { return }
        UIView.animate(withDuration: 0.25, animations: {
            dropdown.alpha = 0
        }, completion: { _ in
            dropdown.removeFromSuperview()
        })
        dropDownView = nil
        isDropDownVisible = false
    }
    
    @objc private func updatePrices() {
        ultimateCollectionView.reloadData()
    }
    
    // MARK: - Location Storage

    func restoreLocation() {
        if let savedLocation = UserDefaults.standard.string(forKey: "selectedLocation"),
           let location = LocationOption(rawValue: savedLocation),
           let savedCurrencyRaw = UserDefaults.standard.string(forKey: "selectedCurrency"),
           let savedCurrency = Currency(rawValue: savedCurrencyRaw) {
            
            actualAddressPick.setTitle(location.rawValue, for: .normal)
            
            CurrencyManager.shared.updateCurrency(to: savedCurrency) {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .currencyDidChange, object: savedCurrency)
                }
            }
    }
    }

}

extension Notification.Name {
    static let currencyDidChange = Notification.Name("currencyDidChange")
}

// Main VC - Benazir Manuchehri

// MARK: - Imports

import UIKit
import DesignSystem
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Variables
    
    let viewModel = MainViewModel()
    
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
        button.setTitle("Dushanbe, Tajikistan", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = AppColors.arsenicDark
        button.setTitleColor(AppColors.arsenicDark, for: .normal)
        button.titleLabel?.font = AppFont.medium_18pt(size: 16)
        return button
    }()
    
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
        configureCollectionConstraints()
        bindViewModel()
    }
    
    // MARK: - AddSubViews
    
    func addSubViews() {
        view.addSubview(cartButton)
        view.addSubview(deliveryAddressLabel)
        view.addSubview(actualAddressPick)
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
        
        actualAddressPick.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
    }
    
    // MARK: - Data Centre
    
    func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.ultimateCollectionView.reloadData()
            }
        }
        viewModel.loadMockData()
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
                    heightDimension: .absolute(230)
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
                section.orthogonalScrollingBehavior = .continuous
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
    private lazy var ultimateCollectionView: UICollectionView = {
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
        
        return collectionView
    }()
    
    func configureCollectionConstraints() {
        view.addSubview(ultimateCollectionView)
        
        ultimateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(actualAddressPick.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
    }
    
    // MARK: - Handle Location Button
    
    @objc func selectLocation() {
        print("showing different locations..")
    }

}

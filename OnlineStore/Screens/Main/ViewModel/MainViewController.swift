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
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        addSubViews()
        configureConstraints()
        configureCollectionConstraints()
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
    
    // MARK: - Compositional Layout
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionType = SectionType(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .categories:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(0.3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .absolute(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .products, .specials:
                return nil
                
            }
            
        }
    }
    
    // MARK: - CollectionView
    private lazy var ultimateCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    func configureCollectionConstraints() {
        view.addSubview(ultimateCollectionView)
        
        ultimateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(actualAddressPick.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Handle Location Button
    
    @objc func selectLocation() {
        print("showing different locations..")
    }

}

// MARK: - UICollectionView DataSource and Delegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .categories:
            return viewModel.categories.count
        case .products, .specials:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else { fatalError() }
        
        switch sectionType {
        case .categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
            cell.configure(with: viewModel.categories[indexPath.item].name)
            return cell
        case .products, .specials:
            return UICollectionViewCell()
        }
    }
}


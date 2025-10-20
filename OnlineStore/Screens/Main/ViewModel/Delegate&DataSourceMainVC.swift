
import UIKit
import DesignSystem

// MARK: - UICollectionView DataSource and Delegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    // MARK: - NumberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .categories:
            return viewModel.categories.count
        case .products:
            return viewModel.products.count
        case .specials:
            return 1
        }
    }
    
    // MARK: - CellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else { fatalError() }
        
        switch sectionType {
        case .categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
            let isSelected = indexPath == selectedIndexPath
            cell.configure(with: viewModel.categories[indexPath.item].name, selected: isSelected)
            return cell
        case .products:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
            let product = viewModel.products[indexPath.item]
            cell.configure(with: product)
            return cell
        case .specials:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebCollectionViewCell.identifier, for: indexPath) as! WebCollectionViewCell
            return cell
        }
    }
    
    // MARK: - DidSelectItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = SectionType(rawValue: indexPath.section) else { fatalError() }
        
        switch sectionType {
        case .categories:
            // UI
            if let oldCell = collectionView.cellForItem(at: selectedIndexPath) as? CategoriesCollectionViewCell {
                oldCell.updateSelection(selected: false, animated: true)
            }
            if let newCell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
                newCell.updateSelection(selected: true, animated: true)
            }

            selectedIndexPath = indexPath
            
            let apiCategory = viewModel.categories[indexPath.item]
            let categoryName = apiCategory.name.lowercased()

            if let categoryEnum = Categories(rawValue: categoryName) {
                viewModel.loadProducts(for: categoryEnum) { [weak self] in
                    DispatchQueue.main.async {
                        self?.ultimateCollectionView.reloadSections(IndexSet(integer: SectionType.products.rawValue))
                    }
                }
            } else {
                print("Unknown category from API:", categoryName)
            }
        case .products:
            let product = (sectionType == .products) ? viewModel.products[indexPath.item] : viewModel.products[indexPath.item]
            let productId = product.id ?? 0
            
            let detailNetworkingManager = DetailNetworkingManager()
            
            detailNetworkingManager.fetchProductDetail(id: productId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detail):
                        let detailsVC = ProductDetailViewController(productInfo: detail)
                        detailsVC.modalPresentationStyle = .fullScreen
                        self?.present(detailsVC, animated: true)
                    case .failure(let error):
                        print("Failed to fetch product details:", error)
                    }
                }
            }
        case .specials:
            break

        }
    }
    
    // MARK: - ViewForSupplementaryElementOfKind
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderReusableView.identifier,
            for: indexPath
        ) as! SectionHeaderReusableView
        
        if indexPath.section == 2 {
            header.configure(title: "Special for you" ,section: indexPath.section)
        }
         else {
            header.configure(title: "" ,section: indexPath.section)
        }
        return header
    }
}


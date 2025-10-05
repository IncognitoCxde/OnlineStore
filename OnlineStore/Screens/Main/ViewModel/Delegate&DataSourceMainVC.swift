// MARK: - UICollectionView DataSource and Delegate

import UIKit

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
            let isSelected = indexPath == selectedIndexPath
            cell.configure(with: viewModel.categories[indexPath.item].name, selected: isSelected)
            return cell
        case .products, .specials:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let oldCell = collectionView.cellForItem(at: selectedIndexPath) as? CategoriesCollectionViewCell {
            oldCell.updateSelection(selected: false, animated: true)
        }
        
        if let newCell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
            newCell.updateSelection(selected: true, animated: true)
        }
        
        selectedIndexPath = indexPath
    }
}


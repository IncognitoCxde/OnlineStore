// MARK: - UICollectionView DataSource and Delegate

import UIKit
import DesignSystem

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let oldCell = collectionView.cellForItem(at: selectedIndexPath) as? CategoriesCollectionViewCell {
            oldCell.updateSelection(selected: false, animated: true)
        }
        
        if let newCell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
            newCell.updateSelection(selected: true, animated: true)
        }
        
        selectedIndexPath = indexPath
    }
    
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


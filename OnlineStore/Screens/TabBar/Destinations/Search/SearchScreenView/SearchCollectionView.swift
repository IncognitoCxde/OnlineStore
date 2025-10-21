import UIKit
import SnapKit
import DesignSystem

final class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var products: [Product] = []
    
    init(networking: SearchNetworkingProtocol = SearchNetworkingManager()) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 192, height: 230)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = AppColors.lightGrey
        self.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
   
}

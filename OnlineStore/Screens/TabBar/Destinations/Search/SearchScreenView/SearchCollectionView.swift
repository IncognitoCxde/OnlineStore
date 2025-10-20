import UIKit
import SnapKit
import DesignSystem

final class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let networking: SearchNetworkingProtocol
    private var products: [Product] = []
    
    
    init(networking: SearchNetworkingProtocol = SearchNetworkingManager()) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumLineSpacing = 12
        self.networking = networking
        
        super.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = AppColors.lightGrey
        self.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        self.delegate = self
        self.dataSource = self
       
        
        fetchProducts()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Networking
    private func fetchProducts() {
            networking.fetchSearchedProducts(request: "pasta") { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedProducts):
                        self?.products = fetchedProducts
                        self?.reloadData()
                    case .failure(let error):
                        print("Failed to fetch products:", error)
                    }
                }
            }
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

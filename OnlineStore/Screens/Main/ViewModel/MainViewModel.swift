// MainVM for MainVC

import UIKit
import DesignSystem
import Networking

final class MainViewModel {
    
    private(set) var products: [Product] = []
    
    struct ProductResponse: Codable {
        var results: [Product]?
    }
    
    let networkingManager: HomeNetworkingProtocol = HomeNetworkingManager()
    
    public var categories: [CollectionCategory] = [
        CollectionCategory(name: "Clothes"),
        CollectionCategory(name: "Electronics"),
        CollectionCategory(name: "Furniture"),
        CollectionCategory(name: "Miscellaneous"),
        CollectionCategory(name: "Shoes")
    ]
    
//    func loadMockData() {
//        products = [
//            Product(id: 1, title: "Monitor HD 22'inch Display", images: ["Monitor"], price: 299.99),
//            Product(id: 2, title: "Playstation 4 - SSD 128GB", images: ["Playstation"], price: 499.99),
//            Product(id: 3, title: "Airpods pro", images: ["Headphones"], price: 199.99),
//            Product(id: 4, title: "Macbook Pro M2 13'inch", images: ["Mac"], price: 1999.99)
//        ]
//        
//        onDataUpdated?()
//    }
    
    var onDataUpdated: (() -> Void)?
    
    func fetchData(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        
        networkingManager.fetchProducts { result in
            defer { group.leave() }
            switch result {
            case .success(let products):
                print("Products fetched successfully")
                self.products = products
                self.onDataUpdated?()
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    
    }
    
    func products(for section: SectionType) -> [Product] {
        switch section {
        case .products:
            return products
        case .categories, .specials:
            return []
        }
    }
    
    func loadProducts(for category: Categories, completion: @escaping () -> Void) {
        networkingManager.fetchProductsbyCategorySlug(for: category) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                DispatchQueue.main.async {
                    completion()
                    self?.onDataUpdated?()
                }
            case .failure(let error):
                print("Failed fetching products by category:", error)
                DispatchQueue.main.async { completion() }
            }
        }
    }
    
    
    private func normalizeCategoryName(_ name: String) -> String {
        switch name.lowercased() {
        default:
            return name.lowercased()
        }
    }
}

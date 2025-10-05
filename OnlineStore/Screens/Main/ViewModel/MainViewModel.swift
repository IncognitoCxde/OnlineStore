// MainVM for MainVC

import DesignSystem
import UIKit

final class MainViewModel {
    
    private(set) var products: [Product] = []
    
    var categories: [Category] = [
        Category(name: "Clothes"),
        Category(name: "Electronics"),
        Category(name: "Furniture"),
        Category(name: "Miscellaneous"),
        Category(name: "Shoes"),
    ]
    
    func loadMockData() {
        products = [
            Product(id: 1, title: "Monitor HD 22'inch Display", images: ["Monitor"], price: 299.99),
            Product(id: 2, title: "Playstation 4 - SSD 128GB", images: ["Playstation"], price: 499.99),
            Product(id: 3, title: "Airpods pro", images: ["Headphones"], price: 199.99),
            Product(id: 4, title: "Macbook Pro M2 13'inch", images: ["Mac"], price: 1999.99)
        ]
        
        onDataUpdated?()
    }
    
    var onDataUpdated: (() -> Void)?
    
}

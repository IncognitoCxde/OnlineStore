//  HomeNetworkingManager - BM

import UIKit
import Networking

final class HomeNetworkingManager: HomeNetworkingProtocol {
        
    let manager = NetworkingManager()
        
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = manager.createURL(for: .products) else { return }
        manager.makeTask(for: url, completion: completion)
    }
    
    func fetchProductsbyCategorySlug(for category: Categories, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let slug = category.rawValue
        guard let url = manager.createURL(for: .productsByCategorySlug(slug: slug)) else {
            completion(.failure(.invalidURL))
            return
        }        
        manager.makeTask(for: url, completion: completion)
    }
    
}

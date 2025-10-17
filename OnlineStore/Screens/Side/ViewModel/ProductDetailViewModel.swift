//  ProductDetailViewModel - BM

import Foundation

final class ProductDetailViewModel {
    
    let networkingManager: DetailNetworkingProtocol = DetailNetworkingManager()
    
    func fetchProductDetail(for id: Int, completion: @escaping (ProductInfo?) -> Void) {
        networkingManager.fetchProductDetail(id: id) { result in
            switch result {
            case .success(let detail):
                completion(detail)
            case .failure(let error):
                print("Failed to fetch product detail: \(error)")
                completion(nil)
            }
        }
    }
}

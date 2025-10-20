//  DetailNetworking - BM

import UIKit
import Networking

protocol DetailNetworkingProtocol {
    func fetchProductDetail(id: Int, completion: @escaping (Result<ProductInfo, NetworkError>) -> Void)
}

final class DetailNetworkingManager: DetailNetworkingProtocol {
    
    let manager = NetworkingManager()

    func fetchProductDetail(id: Int, completion: @escaping (Result<ProductInfo, NetworkError>) -> Void) {
        guard let url = manager.createURL(for: .details(id: id)) else {
            completion(.failure(.noData))
            return
        }
        manager.makeTask(for: url, completion: completion)
    }
    
}

//  SearchNetworking - BM

import UIKit
import Networking

protocol SearchNetworkingProtocol {
    func fetchSearchedProducts(request: String, completion: @escaping (Result<[Product], NetworkError>) -> Void)
}

final class SearchNetworkingManager: SearchNetworkingProtocol {
    
    let manager = NetworkingManager()
    
    func fetchSearchedProducts(request: String, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = manager.createURL(for: .search(request: request)) else { return }
        manager.makeTask(for: url, completion: completion)
    }
    
}


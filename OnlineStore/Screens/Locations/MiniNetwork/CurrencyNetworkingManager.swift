//  Currency Networking Manager

import UIKit
import Networking

public protocol CurrencyNetworkingProtocol {
    func fetchRates(base: String, completion: @escaping (Result<CurrencyResponse, NetworkError>) -> Void)
}

public struct CurrencyResponse: Codable {
    public let base_code: String
    public let conversion_rates: [String: Double]
}

struct CurrencyNetworkingManager: CurrencyNetworkingProtocol {
    
    private let networkManager = NetworkingManager()
    
    func fetchRates(base: String, completion: @escaping (Result<CurrencyResponse, NetworkError>) -> Void) {
        var components = URLComponents()
        components.scheme = APICurrency.scheme
        components.host = APICurrency.host
        components.path = Endpoints.latest(base: base).path
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        networkManager.makeTask(for: url, completion: completion)
    }
}

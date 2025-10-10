//  HomeNetworkingProtocol

import UIKit
import Networking

protocol HomeNetworkingProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void)
    func fetchProductsbyCategorySlug(for category: Categories, completion: @escaping (Result<[Product], NetworkError>) -> Void)
}



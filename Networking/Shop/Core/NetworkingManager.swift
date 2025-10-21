// Networking Manager BM

import Foundation

public struct NetworkingManager {
    
    public init() {}
    
    // MARK: - URL Factory
    
    public func createURL(for endPoint: Endpoint, with query: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endPoint.path
        
        components.queryItems = makeParameters(for: endPoint, with: query).map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    }
    
    // MARK: - Parameters Factory
    
    public func makeParameters(for endpoint: Endpoint, with query: String?) -> [String: String] {
        var parameters = [String: String]()
        
        switch endpoint {
        case .products:
            parameters["offset"] = "0"
            parameters["limit"] = "4"
        case .details(id: let id):
            parameters["id"] = "\(id)"
        case .search(request: let request):
            parameters["offset"] = "0"
            parameters["limit"] = "10"
            parameters["title"] = "\(request)"
        case .productsByCategorySlug(let slug):
            parameters["categorySlug"] = slug
            parameters["offset"] = "0"
            parameters["limit"] = "4"
        }
        return parameters
    }
    
    // MARK: - Task Maker Manager
    
    public func makeTask<T: Codable>(for url: URL, using session: URLSession = .shared, completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.transportError(error)))
                }
                return
            }
            
            guard response is HTTPURLResponse else {
                let error = NSError(domain: "No HTTP URLResponse", code: 0, userInfo: nil)
                completion(.failure(.serverError(statusCode: error.code)))
                return
            }
            
            guard let data = data else {
                _ =  NSError(domain: "No data", code: 0, userInfo: nil)
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
}

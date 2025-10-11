// Network error

public enum NetworkError: Error {
    case noInternet
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
    case encodingError(Error)
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
}


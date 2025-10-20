//  Endpoint enum

public enum Endpoints {
    case latest(base: String)
    
    public var path: String {
        switch self {
        case .latest(base: let base):
            return "/v6/\(APICurrency.apiKey)/latest/\(base)"
        }
    }
}

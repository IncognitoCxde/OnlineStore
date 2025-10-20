// Endpoints

public enum Endpoint {
    case products
    case search(request: String)
    case productsByCategorySlug(slug: String)
    case details(id: Int)
    
    var path: String {
        switch self {
        case .products, .search, .productsByCategorySlug:
            return "/api/v1/products"
        case .details(let id):
            return "/api/v1/products/\(id)"
        }
    }
}

//  SectionType

enum SectionType: Int, CaseIterable {
    case categories
    case products
    case specials
    
    var title: String {
        switch self {
        case .categories: return ""
        case .products: return ""
        case .specials: return "Special for you"
        }
    }
}

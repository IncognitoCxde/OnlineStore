//  Currency Enum

enum Currency: String, CaseIterable {
    case tjs = "TJS"
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case uah = "UAH"
    
    var symbol: String {
        switch self {
        case .tjs: return "TJS"
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .uah: return "₴"
        }
    }
}

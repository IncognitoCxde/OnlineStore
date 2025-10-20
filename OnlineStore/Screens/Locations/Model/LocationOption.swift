//  LocationOptions

import UIKit

enum LocationOption: String, CaseIterable {
    case taj = "Dushanbe, Tajikistan"
    case usa = "NYC, United States"
    case germany = "München, Germany"
    case uk = "London, United Kingdom"
    case ua = "Kyiv, Ukraine"
    
    var flag: String {
        switch self {
        case .taj:
            return "🇹🇯"
        case .usa:
            return "🇺🇸"
        case .germany:
            return "🇩🇪"
        case .uk:
            return "🇬🇧"
        case .ua:
            return "🇺🇦"
        }
    }
    
    var currencyCode: String {
        switch self {
        case .taj:
            return "TJS"
        case .usa:
            return "$"
        case .germany:
            return "€"
        case .uk:
            return "£"
        case .ua:
            return "₴"
        }
    }
}

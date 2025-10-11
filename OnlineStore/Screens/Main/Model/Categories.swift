//  Categories

enum Categories: String, Equatable {
    case clothes = "clothes"
    case electronics = "electronics"
    case furniture = "furniture"
    case shoes = "shoes"
    case miscellaneous = "miscellaneous"
    
    var stringValue: String {
        rawValue
    }
}

// Product

public struct Product: Codable {
    public let id: Int?
    public let title: String?
    public let images: [String]?
    public let price: Double?

    public init(id: Int?, title: String?, images: [String]?, price: Double?) {
        self.id = id
        self.title = title
        self.images = images
        self.price = price
    }
}

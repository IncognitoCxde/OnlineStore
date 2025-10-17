//  CartManager

import Foundation

final class CartManager {
    static let shared = CartManager()
    private init() {}

    private(set) var items: [ProductInfo] = []

    func add(_ product: ProductInfo) {
        items.append(product)
    }

    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
    }

    func clear() {
        items.removeAll()
    }
}

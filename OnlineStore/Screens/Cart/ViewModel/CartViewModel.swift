//  CartViewModel


import Foundation

final class CartViewModel {
    var items: [ProductInfo] {
        CartManager.shared.items
    }

    func removeItem(at index: Int) {
        CartManager.shared.removeItem(at: index)
    }

    func clear() {
        CartManager.shared.clear()
    }
}

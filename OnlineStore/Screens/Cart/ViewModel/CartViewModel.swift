//  CartViewModel

import Foundation

final class CartViewModel {
    
    private let cartManager = CartManager.shared

    // MARK: - Items
    
    var items: [CartItem] {
        return cartManager.items
    }
    
    // MARK: - The functions n stuff (increase/decrease/add/remove)
    func addItem(_ item: CartItem) {
        cartManager.addItem(item)
    }

    func removeItem(_ item: CartItem) {
        cartManager.removeItem(item)
    }

    func increaseQuantity(for item: CartItem, to quantity: Int) {
        cartManager.updateQuantity(for: item, to: quantity)
    }

    func decreaseQuantity(for item: CartItem, to quantity: Int) {
        cartManager.updateQuantity(for: item, to: quantity)
    }

    func toggleSelection(for item: CartItem) {
        cartManager.toggleSelection(for: item)
    }

    
    // MARK: - Helper 4 total price
    
    func totalSelectedPrice() -> Double {
        return cartManager.items
            .filter { $0.isSelected }
            .map { $0.totalPrice }
            .reduce(0, +)
    }
    
    func totalPriceString() -> String {
        let total = cartManager.totalSelectedPrice
        let convertedTotal = CurrencyManager.shared.convert(priceInUSD: total)
        return convertedTotal
    }

}

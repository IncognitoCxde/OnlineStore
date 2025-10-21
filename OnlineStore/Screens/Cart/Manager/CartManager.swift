//  CartManager

import Foundation

final class CartManager {
    
    static let shared = CartManager()
    
    private init() {}

    private(set) var items: [CartItem] = [] {
        didSet {
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
    }

    // MARK: - Add Item
    
    func addItem(_ item: CartItem) {
        if let index = items.firstIndex(where: { $0.name == item.name }) {
            var newItems = items
            newItems[index].quantity += item.quantity
            items = newItems
        } else {
            items.append(item)
        }
    }

    // MARK: - Remove Item
    
    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    // MARK: - Update Quantity
    
    func updateQuantity(for item: CartItem, to quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity = quantity
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    // MARK: - Toggle Selection
    
    func toggleSelection(for item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        var newItems = items
        newItems[index].isSelected.toggle()
        items = newItems
    }

    // MARK: - Totals
    
    var totalSelectedPrice: Double {
        items.filter { $0.isSelected }.map { $0.totalPrice }.reduce(0, +)
    }

    var totalItemCount: Int {
        items.filter { $0.isSelected }.map { $0.quantity }.reduce(0, +)
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}


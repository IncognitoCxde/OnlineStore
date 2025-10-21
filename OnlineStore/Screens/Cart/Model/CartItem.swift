//  CartItem for Cart VC & Manager, VM

import Foundation

struct CartItem: Equatable, Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    let price: Double
    var quantity: Int
    var isSelected: Bool

    var totalPrice: Double {
        return price * Double(quantity)
    }
}

var itemDefault = CartItem(
    id: UUID(),
    name: "",
    imageName: "",
    price: 0,
    quantity: 0,
    isSelected: false
)


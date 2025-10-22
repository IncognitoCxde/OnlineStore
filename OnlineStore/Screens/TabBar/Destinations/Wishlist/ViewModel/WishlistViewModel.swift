import Foundation

final class WishlistViewModel {
    private(set) var items: [ProductInfo] = []
    private(set) var filteredItems: [ProductInfo] = []
    var onUpdate: (() -> Void)?

    init() {
        FavoritesManager.shared.observe { [weak self] in
            self?.loadFavorites()
        }
    }

    func loadFavorites() {
        items = FavoritesManager.shared.getItems()
        filteredItems = items
        onUpdate?()
    }

    func remove(_ product: ProductInfo) {
        guard let id = product.id else { return }
        FavoritesManager.shared.remove(id)
    }

    func search(_ text: String) {
        let query = text.lowercased().trimmingCharacters(in: .whitespaces)

        filteredItems = query.isEmpty ? items : items.filter {
            ($0.title ?? "").lowercased().contains(query)
        }

        onUpdate?()
    }
}

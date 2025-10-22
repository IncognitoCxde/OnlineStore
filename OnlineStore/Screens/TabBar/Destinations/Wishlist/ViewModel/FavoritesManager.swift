import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favoriteItems"

    private init() {}

    func add(_ product: ProductInfo) {
        var items = getItems()
        guard !items.contains(where: { $0.id == product.id }) else { return }
        items.append(product)
        save(items)
        notifyObservers()
    }

    func remove(_ id: Int) {
        var items = getItems()
        items.removeAll { $0.id == id }
        save(items)
        notifyObservers()
    }

    func isFavorite(_ id: Int) -> Bool {
        getItems().contains(where: { $0.id == id })
    }

    func getItems() -> [ProductInfo] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([ProductInfo].self, from: data) else {
            return []
        }
        return items
    }

    private func save(_ items: [ProductInfo]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // Observer logic 
    private var observers: [() -> Void] = []
    func observe(_ callback: @escaping () -> Void) {
        observers.append(callback)
    }
    private func notifyObservers() {
        observers.forEach { $0() }
    }
}

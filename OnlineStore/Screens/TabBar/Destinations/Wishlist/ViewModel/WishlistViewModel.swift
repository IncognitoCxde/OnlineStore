import Foundation

enum WishlistSortOption {
    case priceLowToHigh
    case priceHighToLow
    case none
}

final class WishlistViewModel {

    private(set) var items: [FavoriteItem] = []
    private(set) var filteredItems: [FavoriteItem] = []
    private var lastSearchText: String = ""
    private var currentSort: WishlistSortOption = .none

    var onUpdate: (() -> Void)?

    func loadFavorites() {
        guard let manager = try? getCoreDataManager() else {
            print("CoreDataManager unavailable")
            return
        }

        items = manager.fetchFavorites()
        applyFilters()
    }

    func search(_ text: String) {
        lastSearchText = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        applyFilters()
    }

    func sort(by option: WishlistSortOption) {
        currentSort = option
        applyFilters()
    }

    func remove(_ item: FavoriteItem) {
        guard let manager = try? getCoreDataManager() else { return }
        manager.remove(item)
        loadFavorites()
    }

    private func applyFilters() {
        // Поиск
        if lastSearchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter {
                ($0.title?.lowercased().contains(lastSearchText) ?? false) ||
                ($0.imageName?.lowercased().contains(lastSearchText) ?? false)
            }
        }

        // Сортировка
        switch currentSort {
        case .priceLowToHigh:
            filteredItems.sort { $0.price < $1.price }
        case .priceHighToLow:
            filteredItems.sort { $0.price > $1.price }
        case .none:
            break
        }

        onUpdate?()
    }

    private func getCoreDataManager() throws -> CoreDataManager {
        return CoreDataManager.shared
    }
}

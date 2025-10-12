import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    // MARK: - Persistent Container

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OnlineStore") // имя должно совпадать с .xcdatamodeld
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData error: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Favorites

    func fetchFavorites() -> [FavoriteItem] {
        let request: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }

    func add(product: Product) {
        let item = FavoriteItem(context: context)
        item.id = String(product.id ?? 0)
        item.title = product.title ?? "Untitled"
        item.imageName = product.images?.first ?? ""
        item.price = product.price ?? 0.0
        save()
    }

    func remove(_ item: FavoriteItem) {
        context.delete(item)
        save()
    }

    func isFavorite(id: String) -> Bool {
        let request: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.count(for: request) > 0
        } catch {
            print("isFavorite error: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Save

    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
}

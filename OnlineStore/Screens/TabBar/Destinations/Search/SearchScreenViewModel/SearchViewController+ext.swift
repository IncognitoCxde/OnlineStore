import UIKit
import SnapKit

extension SearchViewController: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            self.collection.isHidden = true
        }

        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.collection.isHidden = false
            return
        }

        networkManager.fetchSearchedProducts(request: trimmed) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.collection.products = response
                    self?.collection.reloadData()
                case .failure(let error):
                    print("Networking failed: \(error)")
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text {
            self.searchBar(searchBar, textDidChange: query)
        }
        print("test search bar delegate - search button clicked")
    }

    func endSearch() {
        collection.isHidden = false
    }
}

extension SearchView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBar(searchBar, textDidChange: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarSearchButtonClicked(searchBar)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.endSearch()
    }

}



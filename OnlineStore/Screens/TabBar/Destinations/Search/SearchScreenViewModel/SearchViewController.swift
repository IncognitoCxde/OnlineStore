// Search VC

import UIKit
import SnapKit
import DesignSystem

class SearchViewController: UIViewController {
    
    var searchView = SearchView()
    var collection = CollectionView()
    var networkManager = SearchNetworkingManager()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search result for \"Trending Now\" "
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.extraLight_18pt(size: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        addSubviews()
        setupCollection()
        makeConstraints()
        searchView.delegate = self
    }
    
    func addSubviews() {
        [searchView, searchLabel, collection].forEach{view.addSubview($0)}
    }
    
    func setupCollection() {
        collection.showsVerticalScrollIndicator = false
        collection.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
    func makeConstraints() {
        searchView.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().inset(9)
            make.height.equalTo(77)
        }
        
        searchLabel.snp.makeConstraints{make in
            make.top.equalTo(searchView.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        collection.snp.makeConstraints{make in
            make.top.equalTo(searchLabel.snp.bottom).offset(21)
            make.left.right.equalToSuperview().inset(4)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(4)
        }
    }
}

extension SearchViewController: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // todo: разобраться где тут должен быть isHidden, когда переводить в false
        if searchText.isEmpty {
//            self.collection.isHidden = true
        }

        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            // todo: разобраться где тут должен быть isHidden, когда переводить в false
//            self.collection.isHidden = true
            return
        }

        networkManager.fetchSearchedProducts(request: trimmed) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.collection.products = response
                    self?.collection.reloadData()
//                    print("Result for the latest request (\(trimmed)): \(response)")
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
        collection.isHidden = true
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



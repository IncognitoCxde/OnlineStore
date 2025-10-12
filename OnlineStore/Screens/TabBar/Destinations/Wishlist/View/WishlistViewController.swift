import UIKit
import SnapKit
import DesignSystem

class WishlistViewController: UIViewController {

    private let viewModel = WishlistViewModel()
    private let searchBar = UISearchBar()
    private let emptyStateView = EmptyStateView(message: "Your wishlist is empty")
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 240)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 24
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadFavorites()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey

        searchBar.placeholder = "Search favorites"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear

        emptyStateView.isHidden = true
        emptyStateView.onAction = { [weak self] in
            guard let tabBarController = self?.tabBarController else {
                self?.navigationController?.popToRootViewController(animated: true)
                return
            }
            tabBarController.selectedIndex = 0 // переключаемся на первую вкладку (главная)
        }

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WishlistCell.self, forCellWithReuseIdentifier: "WishlistCell")
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        emptyStateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
            self?.emptyStateView.isHidden = !(self?.viewModel.filteredItems.isEmpty ?? true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension WishlistViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText)
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as? WishlistCell else {
            return UICollectionViewCell()
        }

        let item = viewModel.filteredItems[indexPath.item]
        cell.configure(with: item)
        cell.onHeartTapped = { [weak self] in
            self?.viewModel.remove(item)
        }

        return cell
    }
}

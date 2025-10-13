import UIKit
import SnapKit
import DesignSystem

class WishlistViewController: UIViewController {

    private let viewModel = WishlistViewModel()

    private let searchBarView = SearchBarView()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarView.focus()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey

        searchBarView.onTextChanged = { [weak self] text in
            self?.viewModel.search(text)
            self?.collectionView.reloadData()
        }

        // Добавлено действие для кнопки Go shopping
        emptyStateView.onAction = { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }

        view.addSubview(searchBarView)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)

        view.bringSubviewToFront(searchBarView)

        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(12)
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

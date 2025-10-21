import UIKit
import SnapKit
import DesignSystem

class WishlistViewController: UIViewController {

    private let viewModel = WishlistViewModel()
    private let searchBarView = SearchBarView()
    private let emptyStateView = EmptyStateView(message: "Your wishlist is empty")

    private let layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let spacing: CGFloat = 12
        let itemsPerRow: CGFloat = traitCollection.horizontalSizeClass == .regular ? 3 : 2
        let totalSpacing = spacing * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = floor(availableWidth / itemsPerRow)

        layout.itemSize = CGSize(width: itemWidth, height: 240)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = 24
    }

    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey

        searchBarView.onTextChanged = { [weak self] text in
            self?.viewModel.search(text)
        }

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

        collectionView.register(WishlistCell.self, forCellWithReuseIdentifier: "WishlistCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .zero
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
        cell.onHeartTapped = { [weak self] product in
            self?.viewModel.remove(product)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.filteredItems[indexPath.item]
        let detailVC = ProductDetailViewController(productInfo: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

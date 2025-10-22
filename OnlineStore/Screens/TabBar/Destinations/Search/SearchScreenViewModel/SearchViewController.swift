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


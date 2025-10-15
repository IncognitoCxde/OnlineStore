import UIKit
import SnapKit
import DesignSystem

class SearchViewController: UIViewController {
    
    let searchView = SearchView()
    let collection = CollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        addSubviews()
        makeConstraints()
        
    }
    
    func addSubviews() {
        [searchView, collection].forEach{view.addSubview($0)}
    }
    
    
    func setupCollection() {
        collection.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
    func makeConstraints() {
        searchView.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collection.snp.makeConstraints{make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(4)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(4)
        }
    }
}




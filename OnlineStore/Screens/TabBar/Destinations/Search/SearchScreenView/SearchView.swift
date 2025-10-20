import UIKit
import SnapKit
import DesignSystem

final class SearchView: UIView {

//     MARK: - UI Properties
    private var searchBar: UISearchBar = {
        let search = UISearchBar()
        let image = AppIcons.search.withTintColor(AppColors.arsenicDark, renderingMode: .alwaysOriginal)
        search.setImage(image, for: .search, state: .normal)
        search.placeholder = "Search here..."
        search.backgroundColor = AppColors.lightGrey
        search.searchBarStyle = .minimal
        search.searchTextField.returnKeyType = .go
        search.keyboardType = .webSearch
        return search
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(AppColors.arsenicDark, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(searchBar)
        addSubview(cancelButton)
        
    }
    
    func makeConstraints() {
        searchBar.snp.makeConstraints {make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(11)
            make.width.equalTo(301)
            make.height.equalTo(50)
        }
        cancelButton.snp.makeConstraints{make in
            make.left.equalTo(searchBar.snp.right)
            make.width.equalTo(80)
            make.height.equalToSuperview()
        }
    }
    
    @objc func tappedCancelButton() {
        searchBar.resignFirstResponder()
    }
}



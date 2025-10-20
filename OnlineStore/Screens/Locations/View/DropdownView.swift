//  DropdownView for Locations

import UIKit
import SnapKit
import DesignSystem

final class DropdownView: UIView, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    var didSelectItem: ((LocationOption) -> Void)?

    private var items: [LocationOption] = []

    init(items: [LocationOption]) {
        self.items = items
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = AppColors.lightGrey
        layer.shadowColor = AppColors.arsenicDark.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = AppColors.lightGrey
        
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
        let location = LocationOption.allCases[indexPath.row]
        cell.titleLabel.text = "\(location.flag) \(location.rawValue)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = items[indexPath.row]
        didSelectItem?(selected)
    }
}

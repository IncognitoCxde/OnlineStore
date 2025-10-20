//  LocationTableViewCell for Location picker

import UIKit
import DesignSystem
import SnapKit

class LocationTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: LocationTableViewCell.self)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.medium_18pt(size: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    

}

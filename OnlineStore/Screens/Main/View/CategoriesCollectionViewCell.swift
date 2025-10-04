//  CategoriesCollectionViewCell

import UIKit
import DesignSystem
import SnapKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CategoriesCollectionViewCell.self)

    let label: UILabel = {
        let label = UILabel()
        label.font = AppFont.medium_18pt(size: 17)
        label.textColor = AppColors.arsenicDark
        label.textAlignment = .center
        return label
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
}

//  SectionHeaderReusableView

import UIKit
import SnapKit
import DesignSystem

class SectionHeaderReusableView: UICollectionReusableView {
    
    static let identifier = String(describing: SectionHeaderReusableView.self)
    
    var section: Int = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.medium_18pt(size: 18)
        label.textColor = AppColors.arsenicDark
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func configure(title: String, section: Int) {
        titleLabel.text = title
        self.section = section
    }
}



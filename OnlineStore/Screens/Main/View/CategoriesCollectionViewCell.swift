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
        
    let bgView: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 12
        bg.layer.shadowColor = AppColors.customBlue.cgColor
        bg.layer.shadowOffset = CGSize(width: 6, height: 2)
        bg.layer.shadowOpacity = 0.8
        bg.layer.shadowRadius = 5
        return bg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgView)
        contentView.addSubview(label)
        configureBg()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureBg() {
        bgView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.top).offset(-4)
            make.bottom.equalTo(label.snp.bottom).offset(4)
            make.leading.equalTo(label.snp.leading).offset(1)
            make.trailing.equalTo(label.snp.trailing).offset(1)
        }
//        bgView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    
    func configure(with text: String, selected: Bool) {
        label.text = text
        updateSelection(selected: selected, animated: false)
    }
    
    func updateSelection(selected: Bool, animated: Bool) {
        let changes = {
            self.bgView.backgroundColor = selected ? AppColors.vanilla : .clear
            self.bgView.transform = selected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
        }
        animated ? UIView.animate(withDuration: 0.15, animations: changes) : changes()
    }
    
}

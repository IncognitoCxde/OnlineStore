//  CategoriesCollectionViewCell BM

// MARK: - Imports

import UIKit
import DesignSystem
import SnapKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CategoriesCollectionViewCell.self)
    
    // MARK: - Variables
    
    let label: UILabel = {
        let label = UILabel()
        label.font = AppFont.medium_18pt(size: 17)
        label.textColor = AppColors.arsenicDark
        label.textAlignment = .center
        return label
    }()
        
    let bgView: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 9
        bg.layer.masksToBounds = false
        return bg
    }()
    
    // MARK: - Init
    
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
    
    // MARK: - Configuration & Constraints
    
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
            make.top.equalTo(label.snp.top).offset(-7)
            make.bottom.equalTo(label.snp.bottom).offset(7)
            make.leading.equalTo(label.snp.leading).inset(8)
            make.trailing.equalTo(label.snp.trailing).inset(8)
           
        }
    }
    
    func configure(with text: String, selected: Bool) {
        label.text = text
        updateSelection(selected: selected, animated: false)
    }
    
    // MARK: - Selection Handler
    
    func updateSelection(selected: Bool, animated: Bool) {
        let changes = {
            self.bgView.backgroundColor = selected ? AppColors.vanilla : .clear
            self.bgView.transform = selected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
            
            if selected {
                self.bgView.layer.shadowColor = AppColors.customBlue.cgColor
                self.bgView.layer.shadowOffset = CGSize(width: 6, height: 3)
                self.bgView.layer.shadowOpacity = 1.5
                self.bgView.layer.shadowRadius = 9
                self.bgView.layer.shadowPath = UIBezierPath(
                    roundedRect: self.bgView.bounds,
                    cornerRadius: 9
                ).cgPath
            } else {
                self.bgView.layer.shadowOpacity = 0
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.15, animations: changes)
        } else {
            changes()
        }
    }
    
}

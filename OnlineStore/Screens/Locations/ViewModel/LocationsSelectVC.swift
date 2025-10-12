//  LocationsSelectVC - BM

import UIKit
import DesignSystem
import SnapKit

class LocationsSelectVC: UIViewController {
    
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUpTitleLabel()
        setUpConstraints()
    }
    
    func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.textColor = AppColors.arsenicDark
        titleLabel.font = AppFont.semiBold_18pt(size: 18)
        titleLabel.textAlignment = .center
        titleLabel.text = "Select Location"
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
    }
}

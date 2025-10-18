
//  WebCollectionViewCell for MainVC

import UIKit
import WebKit
import SnapKit
import DesignSystem

class WebCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: WebCollectionViewCell.self)
    let webView: WKWebView = {
        let wbv = WKWebView()
        wbv.load(URLRequest(url: URL(string: "https://akns-images.eonline.com/eol_images/Entire_Site/2022917/rs_1024x759-221017110819-1024-hm.jpg?fit=around%7C1024:759&output-quality=90&crop=1024:759;center,top")!))
        return wbv
    }()
    
    let saleLabel: UILabel = {
        let label = UILabel()
        label.text = "SALE"
        label.textColor = AppColors.arsenicDark
        label.font = AppFont.bold_28pt(size: 100)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        contentView.addSubview(webView)
        webView.addSubview(saleLabel)
        webView.layer.cornerRadius = 8
        webView.clipsToBounds = true
        
        webView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview().offset(15)
        }
        
        saleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
        
    }
}

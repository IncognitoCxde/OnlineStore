
//  WebCollectionViewCell for MainVC

import UIKit
import WebKit
import SnapKit
import DesignSystem

class WebCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: WebCollectionViewCell.self)
    let webView: WKWebView = {
        let wbv = WKWebView()
        wbv.load(URLRequest(url: URL(string: "https://cdn.hyprop.co.za/image/2023/1/9/84432091-7e55-4796-a29b-849122e4b5cb/5d4f1357-f9fd-4044-b3e4-d1fb74322319.jpg?w=1082&h=608&webp")!))
        return wbv
    }()
    
    let saleLabel: UILabel = {
        let label = UILabel()
        label.text = " SALE 50%"
        label.textColor = AppColors.lightBlue
        label.font = AppFont.bold_28pt(size: 60)
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

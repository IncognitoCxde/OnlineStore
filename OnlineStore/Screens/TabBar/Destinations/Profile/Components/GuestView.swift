import UIKit
import SnapKit
import DesignSystem

final class GuestView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You are not signed in"
        label.font = AppFont.semiBold_18pt(size: 18)
        label.textAlignment = .center
        label.textColor = AppColors.arsenicDark
        return label
    }()

    let actionButton: UIButton = {
        let button = UIButton.makeStyled(style: .authPrimary, title: "Sign In / Sign Up")
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(messageLabel)
        addSubview(actionButton)

        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }

        actionButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


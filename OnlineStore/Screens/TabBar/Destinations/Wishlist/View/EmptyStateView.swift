import UIKit
import SnapKit
import DesignSystem

class EmptyStateView: UIView {

    private let iconView = UIImageView()
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    var onAction: (() -> Void)?

    init(message: String, icon: UIImage = AppIcons.heart, buttonTitle: String = "Go shopping") {
        super.init(frame: .zero)
        setupUI(message: message, icon: icon, buttonTitle: buttonTitle)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI(message: String, icon: UIImage, buttonTitle: String) {
        iconView.image = icon
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = AppColors.arsenicDark
        iconView.snp.makeConstraints { $0.height.equalTo(64) }

        messageLabel.text = message
        messageLabel.font = AppFont.regular18pt(size: 16)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2

        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = AppColors.customBlue
        actionButton.layer.cornerRadius = 10
        actionButton.titleLabel?.font = AppFont.bold_24pt(size: 16)
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        actionButton.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.height.equalTo(44)
        }

        let stack = UIStackView(arrangedSubviews: [iconView, messageLabel, actionButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    @objc private func didTapAction() {
        onAction?()
    }
}

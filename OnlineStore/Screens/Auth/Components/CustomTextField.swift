import UIKit
import SnapKit
import DesignSystem

final class CustomTextField: UIView {

    private let textField = UITextField()
    private let rightIconView = UIImageView()

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    override var inputView: UIView? {
        get { textField.inputView }
        set { textField.inputView = newValue }
    }

    init(placeholder: String, isSecure: Bool = false, showsArrow: Bool = false) {
        super.init(frame: .zero)
        setupUI(placeholder: placeholder, isSecure: isSecure, showsArrow: showsArrow)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(placeholder: String, isSecure: Bool, showsArrow: Bool) {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = AppColors.grey.cgColor
        backgroundColor = AppColors.lightGrey

        let container = UIView()
        addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.font = AppFont.regular18pt(size: 17)
        textField.textColor = AppColors.arsenicDark
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.tintColor = AppColors.customBlue
        textField.setContentHuggingPriority(.required, for: .vertical)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)

        container.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(12)
        }

        if showsArrow {
            rightIconView.image = UIImage(systemName: "chevron.right")
            rightIconView.tintColor = AppColors.grey
            rightIconView.setContentHuggingPriority(.required, for: .horizontal)
            rightIconView.setContentCompressionResistancePriority(.required, for: .horizontal)

            container.addSubview(rightIconView)
            rightIconView.snp.makeConstraints {
                $0.centerY.equalTo(textField)
                $0.trailing.equalToSuperview().inset(12)
                $0.width.height.equalTo(16)
            }

            textField.snp.makeConstraints {
                $0.trailing.equalTo(rightIconView.snp.leading).offset(-8)
            }
        } else {
            textField.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(12)
                $0.height.greaterThanOrEqualTo(24)
            }
        }

        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}

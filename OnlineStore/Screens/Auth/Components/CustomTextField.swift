import UIKit
import SnapKit
import DesignSystem

enum TextFieldMode {
    case email
    case password
    case username
    case generic
}

final class CustomTextField: UIView {

    public let textField = UITextField()
    private let rightIconView = UIImageView()
    private var eyeButton: UIButton?

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    override var inputView: UIView? {
        get { textField.inputView }
        set { textField.inputView = newValue }
    }

    init(placeholder: String,
         isSecure: Bool = false,
         showsArrow: Bool = false,
         showsEyeIcon: Bool = false,
         mode: TextFieldMode = .generic) {
        super.init(frame: .zero)
        setupUI(placeholder: placeholder,
                isSecure: isSecure,
                showsArrow: showsArrow,
                showsEyeIcon: showsEyeIcon)
        setMode(mode)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(placeholder: String, isSecure: Bool, showsArrow: Bool, showsEyeIcon: Bool) {
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

        // 🔹 Базовые настройки: английская раскладка, без автозаглавной и автокоррекции
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no

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
        } else if showsEyeIcon {
            let eye = UIButton(type: .custom)
            eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eye.tintColor = AppColors.grey
            eye.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            eyeButton = eye

            container.addSubview(eye)
            eye.snp.makeConstraints {
                $0.centerY.equalTo(textField)
                $0.trailing.equalToSuperview().inset(12)
                $0.width.height.equalTo(20)
            }

            textField.snp.makeConstraints {
                $0.trailing.equalTo(eye.snp.leading).offset(-8)
                $0.height.greaterThanOrEqualTo(24)
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

    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()

        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton?.setImage(UIImage(systemName: imageName), for: .normal)

        // Цвет глазика
        eyeButton?.tintColor = textField.isSecureTextEntry ? AppColors.grey : AppColors.customBlue

        // caret fix
        let currentText = textField.text
        textField.text = ""
        textField.insertText(currentText ?? "")
    }
    
    public func setValidationState(isValid: Bool?) {
        guard let isValid = isValid else {
            layer.borderColor = AppColors.grey.cgColor
            return
        }
        layer.borderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.red.cgColor
    }

    // метод для переключения режимов
    public func setMode(_ mode: TextFieldMode) {
        switch mode {
        case .email:
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        case .password:
            textField.isSecureTextEntry = true
            textField.keyboardType = .asciiCapable
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        case .username:
            textField.keyboardType = .asciiCapable
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        case .generic:
            textField.keyboardType = .default
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .default
        }
    }
}

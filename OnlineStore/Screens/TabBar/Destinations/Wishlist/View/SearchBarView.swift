import UIKit
import SnapKit
import DesignSystem

final class SearchBarView: UIView {

    var onTextChanged: ((String) -> Void)?

    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: AppIcons.search)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.customBlue
        return imageView
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search here..."
        field.font = AppFont.regular18pt(size: 17)
        field.clearButtonMode = .whileEditing
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.tintColor = AppColors.customBlue
        return field
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }

    private func setupUI() {
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = AppColors.mediumGrey.cgColor
        layer.cornerRadius = 12
        layer.masksToBounds = true

        addSubview(iconImageView)
        addSubview(textField)

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        textField.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(6)
        }
    }

    private func setupActions() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }

    @objc private func textChanged() {
        onTextChanged?(textField.text ?? "")
    }

    func focus() {
        _ = textField.becomeFirstResponder()
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onTextChanged?("")
        return true
    }
}

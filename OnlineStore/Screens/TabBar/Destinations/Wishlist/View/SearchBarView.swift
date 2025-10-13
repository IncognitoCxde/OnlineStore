import UIKit
import SnapKit
import DesignSystem

final class SearchBarView: UIView {

    var onTextChanged: ((String) -> Void)?
    var onCancelTapped: (() -> Void)?

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppIcons.search
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.grey
        return imageView
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search here..."
        field.font = AppFont.regular18pt(size: 17)
        field.textColor = AppColors.arsenicDark
        field.clearButtonMode = .whileEditing
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.tintColor = AppColors.customBlue
        return field
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(AppColors.arsenicDark, for: .normal)
        button.setTitleColor(AppColors.customBlue, for: .selected)
        button.titleLabel?.font = AppFont.regular18pt(size: 15)
        button.alpha = 0
        button.isHidden = true
        return button
    }()

    private let searchContainer = UIView()

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
        let stack = UIStackView(arrangedSubviews: [searchContainer, cancelButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchContainer.layer.borderWidth = 1
        searchContainer.layer.borderColor = AppColors.grey.cgColor
        searchContainer.layer.cornerRadius = 12
        searchContainer.layer.masksToBounds = true
        searchContainer.backgroundColor = .clear

        searchContainer.addSubview(iconImageView)
        searchContainer.addSubview(textField)

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

        searchContainer.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        cancelButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(60)
        }

        searchContainer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
    }

    private func setupActions() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    @objc private func textChanged() {
        let text = textField.text ?? ""
        onTextChanged?(text)

        let shouldShowCancel = !text.isEmpty
        UIView.animate(withDuration: 0.2) {
            self.cancelButton.alpha = shouldShowCancel ? 1 : 0
            self.cancelButton.isHidden = !shouldShowCancel
        }
    }

    @objc private func cancelTapped() {
        textField.text = ""
        onTextChanged?("")
        onCancelTapped?()
        textField.resignFirstResponder()

        UIView.animate(withDuration: 0.2) {
            self.cancelButton.alpha = 0
            self.cancelButton.isHidden = true
        }
    }

    func focus() {
        textField.becomeFirstResponder()
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onTextChanged?("")
        return true
    }
}

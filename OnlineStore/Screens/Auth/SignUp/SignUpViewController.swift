import UIKit
import SnapKit
import DesignSystem

final class SignUpViewController: UIViewController {

    private let viewModel = SignUpViewModel()

    private let nameField = LabeledFieldView(title: "First Name", field: CustomTextField(placeholder: "Enter your name"))
    private let emailField = LabeledFieldView(title: "E-mail", field: CustomTextField(placeholder: "Enter your email"))
    private let passwordField = LabeledFieldView(title: "Password", field: CustomTextField(placeholder: "Enter your password", isSecure: true))
    private let confirmPasswordField = LabeledFieldView(title: "Confirm Password", field: CustomTextField(placeholder: "Confirm your password", isSecure: true))
    private let accountTypeField = LabeledFieldView(
        title: "Account Type",
        field: PickerButtonField(placeholder: "Choose account type")
    )
    private let accountTypes = ["Client", "Manager"]
    private let accountTypePicker = UIPickerView()

    private let signUpButton = UIButton.makeStyled(style: .authPrimary, title: "Sign Up")
    private let switchToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = AppFont.regular18pt(size: 15)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .center
        return button
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete your account"
        label.font = AppFont.bold_28pt(size: 24)
        label.textColor = AppColors.customBlue
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupPicker()
        setupActions()
        setupAttributedLoginText()
    }

    private func setupNavigation() {
        navigationItem.title = "Sign Up"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey

        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(32)
        }

        let stack = UIStackView(arrangedSubviews: [
            nameField,
            emailField,
            passwordField,
            confirmPasswordField,
            accountTypeField,
            signUpButton,
            switchToLoginButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .equalCentering

        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }

        [nameField, emailField, passwordField, confirmPasswordField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(72)
            }
        }
        accountTypeField.snp.makeConstraints {
            $0.height.equalTo(72)
        }

        signUpButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }

    private func setupPicker() {
        if let pickerField = accountTypeField.field as? PickerButtonField {
            pickerField.onTap = { [weak self] in
                self?.showAccountTypeMenu()
            }
        }
    }

    private func showAccountTypeMenu() {
        let alert = UIAlertController(title: "Choose account type", message: nil, preferredStyle: .actionSheet)

        for type in accountTypes {
            alert.addAction(UIAlertAction(title: type, style: .default) { [weak self] _ in
                if let pickerField = self?.accountTypeField.field as? PickerButtonField {
                    pickerField.text = type
                }
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        switchToLoginButton.addTarget(self, action: #selector(switchToLogin), for: .touchUpInside)
    }

    private func setupAttributedLoginText() {
        let fullText = "Already have an account? Login"
        let attributedText = NSMutableAttributedString(string: fullText)

        // Сначала задаём тёмный цвет и шрифт для всего текста
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedText.addAttribute(.foregroundColor, value: AppColors.arsenicDark, range: fullRange)
        attributedText.addAttribute(.font, value: AppFont.regular18pt(size: 15), range: fullRange)

        // Потом переопределяем цвет для "Login"
        if let range = fullText.range(of: "Login") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: AppColors.customBlue, range: nsRange)
        }

        switchToLoginButton.setAttributedTitle(attributedText, for: .normal)
    }

    @objc private func signUpTapped() {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        let accountType = accountTypeField.text ?? ""
        let accountTypeIndex = accountTypes.firstIndex(of: accountType) ?? 0

        viewModel.signUp(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            accountTypeIndex: accountTypeIndex
        ) { [weak self] result in
            switch result {
            case .success:
                UserSession.shared.loadUser { loadResult in
                    switch loadResult {
                    case .success:
                        self?.navigateToMainTab()
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            case .failure(let error):
                self?.showError(error)
            }
        }
    }

    @objc private func switchToLogin() {
        navigationController?.popViewController(animated: true)
    }

    private func navigateToMainTab() {
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        accountTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        accountTypes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickerField = accountTypeField.field as? PickerButtonField {
            pickerField.text = accountTypes[row]
        }
        view.endEditing(true)
    }
}

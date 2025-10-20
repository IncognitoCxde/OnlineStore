import UIKit
import SnapKit
import DesignSystem

final class SignUpViewController: BaseViewController {

    private let viewModel = SignUpViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let nameField = LabeledFieldView(title: "First Name", field: CustomTextField(placeholder: "Enter your name"))
    private let emailField = LabeledFieldView(title: "E-mail", field: CustomTextField(placeholder: "Enter your email"))
    private let passwordField = LabeledFieldView(title: "Password", field: CustomTextField(placeholder: "Enter your password", isSecure: true, showsEyeIcon: true))
    private let confirmPasswordField = LabeledFieldView(title: "Confirm Password", field: CustomTextField(placeholder: "Confirm your password", isSecure: true, showsEyeIcon: true))
    private let accountTypeField = LabeledFieldView(title: "Account Type", field: PickerButtonField(placeholder: "Choose account type"))

    private let accountTypes = ["Client", "Manager"]
    private let accountTypePicker = UIPickerView()

    private let emailHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a valid email address"
        label.font = AppFont.regular18pt(size: 13)
        label.textColor = AppColors.grey
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let passwordHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Minimum 8 characters, one letter and one digit"
        label.font = AppFont.regular18pt(size: 13)
        label.textColor = AppColors.grey
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let signUpButton = UIButton.makeStyled(style: .authPrimary, title: "Sign Up")
    private let switchToLoginButton = UIButton(type: .system)

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
        scrollViewToAdjust = scrollView
        setupNavigation()
        setupUI()
        setupPicker()
        setupActions()
        setupAttributedLoginText()
        setupPasswordValidation()
        setupEmailValidation()
    }

    private func setupNavigation() {
        navigationItem.title = "Sign Up"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        scrollView.keyboardDismissMode = .interactive

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let stack = UIStackView(arrangedSubviews: [
            nameField, emailField, passwordField,
            confirmPasswordField, accountTypeField,
            signUpButton, switchToLoginButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill

        contentView.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        [nameField, emailField, passwordField, confirmPasswordField, accountTypeField].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(72) }
        }
        signUpButton.snp.makeConstraints { $0.height.equalTo(52) }

        contentView.addSubview(emailHintLabel)
        emailHintLabel.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(emailField)
        }

        contentView.addSubview(passwordHintLabel)
        passwordHintLabel.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(passwordField)
        }

        // bottom spacing so scroll content has a bottom
        stack.snp.makeConstraints { $0.bottom.equalToSuperview().inset(32) }

        // setup switchToLoginButton style
        switchToLoginButton.titleLabel?.font = AppFont.regular18pt(size: 15)
        switchToLoginButton.backgroundColor = .clear
        switchToLoginButton.contentHorizontalAlignment = .center
    }

    private func setupPicker() {
        accountTypePicker.delegate = self
        accountTypePicker.dataSource = self

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
                (self?.accountTypeField.field as? PickerButtonField)?.text = type
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let pop = alert.popoverPresentationController {
            pop.sourceView = accountTypeField
            pop.sourceRect = accountTypeField.bounds
        }

        present(alert, animated: true)
    }

    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        switchToLoginButton.addTarget(self, action: #selector(switchToLogin), for: .touchUpInside)
    }

    private func setupAttributedLoginText() {
        let fullText = "Already have an account? Login"
        let attributedText = NSMutableAttributedString(string: fullText)
        let fullRange = NSRange(location: 0, length: fullText.count)

        attributedText.addAttribute(.foregroundColor, value: AppColors.arsenicDark, range: fullRange)
        attributedText.addAttribute(.font, value: AppFont.regular18pt(size: 15), range: fullRange)

        if let range = fullText.range(of: "Login") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: AppColors.customBlue, range: nsRange)
        }

        switchToLoginButton.setAttributedTitle(attributedText, for: .normal)
    }

    private func setupPasswordValidation() {
        if let passwordTF = (passwordField.field as? CustomTextField)?.textField {
            passwordTF.addTarget(self, action: #selector(passwordFieldsChanged), for: .editingChanged)
        }
        if let confirmTF = (confirmPasswordField.field as? CustomTextField)?.textField {
            confirmTF.addTarget(self, action: #selector(passwordFieldsChanged), for: .editingChanged)
        }
    }

    @objc private func passwordFieldsChanged() {
        let password = passwordField.text ?? ""
        let confirm = confirmPasswordField.text ?? ""

        let mainIsValid = PasswordValidator.isValid(password)
        passwordHintLabel.isHidden = false
        passwordHintLabel.textColor = mainIsValid ? .systemGreen : .red
        (passwordField.field as? CustomTextField)?.setValidationState(isValid: mainIsValid)

        if confirm.isEmpty {
            (confirmPasswordField.field as? CustomTextField)?.setValidationState(isValid: nil)
        } else {
            let matches = (password == confirm)
            (confirmPasswordField.field as? CustomTextField)?.setValidationState(isValid: matches)
        }
    }

    private func setupEmailValidation() {
        if let emailTF = (emailField.field as? CustomTextField)?.textField {
            emailTF.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        }
    }

    @objc private func emailChanged() {
        let email = emailField.text ?? ""
        if email.isEmpty {
            (emailField.field as? CustomTextField)?.setValidationState(isValid: nil)
            emailHintLabel.isHidden = true
            return
        }
        let valid = isValidEmail(email)
        (emailField.field as? CustomTextField)?.setValidationState(isValid: valid)
        emailHintLabel.isHidden = false
        emailHintLabel.textColor = valid ? .systemGreen : .red
    }

    @objc private func signUpTapped() {
        let name = nameField.text
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let confirmPassword = confirmPasswordField.text ?? ""
        let accountType = accountTypeField.text ?? ""
        let accountTypeIndex = accountTypes.firstIndex(of: accountType) ?? 0

        // Email validation
        let emailIsValid = isValidEmail(email)
        (emailField.field as? CustomTextField)?.setValidationState(isValid: emailIsValid)
        emailHintLabel.isHidden = false
        emailHintLabel.textColor = emailIsValid ? .systemGreen : .red
        guard emailIsValid else { shake(view: emailField); return }

        // Main password validation
        let mainIsValid = PasswordValidator.isValid(password)
        (passwordField.field as? CustomTextField)?.setValidationState(isValid: mainIsValid)
        passwordHintLabel.isHidden = false
        passwordHintLabel.textColor = mainIsValid ? .systemGreen : .red
        guard mainIsValid else { shake(view: passwordField); return }

        // Confirm password match
        let matches = (password == confirmPassword)
        (confirmPasswordField.field as? CustomTextField)?.setValidationState(isValid: matches)
        guard matches else { shake(view: confirmPasswordField); return }

        // Show loading and call viewModel
        let loading = UIActivityIndicatorView(style: .large)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loading.startAnimating()
        view.isUserInteractionEnabled = false

        viewModel.signUp(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            accountTypeIndex: accountTypeIndex
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                loading.stopAnimating()
                loading.removeFromSuperview()
                self.view.isUserInteractionEnabled = true

                switch result {
                case .success:
                    // Используем расширение showSuccess с авто-дизмисом и completion
                    self.showSuccess(message: "Your account was created successfully", autoDismissInterval: 3.0) {
                        self.proceedAfterSignUp()
                    }
                case .failure(let error):
                    self.showError(error)
                }
            }
        }
    }

    private func proceedAfterSignUp() {
        UserSession.shared.loadUser { [weak self] loadResult in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch loadResult {
                case .success:
                    self.navigateToMainTab()
                case .failure(let error):
                    self.showError(error)
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return false }
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func shake(view: UIView) {
        let anim = CAKeyframeAnimation(keyPath: "transform.translation.x")
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        anim.duration = 0.4
        anim.values = [-8, 8, -6, 6, -3, 3, 0]
        view.layer.add(anim, forKey: "shake")
    }

    @objc private func switchToLogin() {
        navigationController?.popViewController(animated: true)
    }

    private func navigateToMainTab() {
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
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

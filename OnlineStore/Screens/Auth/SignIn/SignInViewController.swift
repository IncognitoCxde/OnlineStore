import UIKit
import SnapKit
import DesignSystem

final class SignInViewController: BaseViewController {

    private let viewModel = SignInViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emailField = LabeledFieldView(
        title: "E-mail",
        field: CustomTextField(
            placeholder: "Enter your email",
            mode: .email
        )
    )

    private let passwordField = LabeledFieldView(
        title: "Password",
        field: CustomTextField(
            placeholder: "Enter your password",
            isSecure: true,
            showsEyeIcon: true,
            mode: .password
        )
    )

    private let passwordHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Minimum 8 characters, one letter and one digit"
        label.font = AppFont.regular18pt(size: 13)
        label.textColor = AppColors.grey
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let signInButton = UIButton.makeStyled(style: .authPrimary, title: "Sign In")
    private let switchToSignUpButton = UIButton.makeStyled(style: .authSecondary, title: "")
    private let skipButton: UIButton = {
        let button = UIButton.makeStyled(style: .authSecondary, title: "Skip for now")
        button.titleLabel?.font = AppFont.regular18pt(size: 15)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewToAdjust = scrollView
        setupNavigation()
        setupUI()
        setupActions()
        setupAttributedSignUpText()
        setupPasswordValidation()
    }

    private func setupNavigation() {
        navigationItem.title = "Sign In"
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

        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
        }

        let stack = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            signInButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill

        contentView.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        [emailField, passwordField].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(72) }
        }
        signInButton.snp.makeConstraints { $0.height.equalTo(52) }

        contentView.addSubview(passwordHintLabel)
        passwordHintLabel.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(passwordField)
        }

        //  Стек для кнопок "Sign Up" и "Skip"
        let bottomStack = UIStackView(arrangedSubviews: [switchToSignUpButton, skipButton])
        bottomStack.axis = .vertical
        bottomStack.spacing = 4
        bottomStack.alignment = .center

        contentView.addSubview(bottomStack)
        bottomStack.snp.makeConstraints {
            $0.top.equalTo(stack.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        switchToSignUpButton.addTarget(self, action: #selector(switchToSignUp), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    }

    private func setupAttributedSignUpText() {
        let fullText = "Don't have an account yet? Sign Up"
        let attributedText = NSMutableAttributedString(string: fullText)

        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedText.addAttribute(.foregroundColor, value: AppColors.arsenicDark, range: fullRange)
        attributedText.addAttribute(.font, value: AppFont.regular18pt(size: 15), range: fullRange)

        if let range = fullText.range(of: "Sign Up") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: AppColors.customBlue, range: nsRange)
        }

        switchToSignUpButton.setAttributedTitle(attributedText, for: .normal)
    }

    private func setupPasswordValidation() {
        (passwordField.field as? CustomTextField)?.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }

    @objc private func passwordChanged() {
        guard let password = passwordField.text else { return }
        let isValid = PasswordValidator.isValid(password)
        passwordHintLabel.isHidden = false
        passwordHintLabel.textColor = isValid ? .systemGreen : .red
        (passwordField.field as? CustomTextField)?.setValidationState(isValid: isValid)
    }

    @objc private func signInTapped() {
        viewModel.signIn(email: emailField.text, password: passwordField.text) { [weak self] result in
            switch result {
            case .success:
                UserSession.shared.loadUser { loadResult in
                    switch loadResult {
                    case .success: self?.navigateToMainTab()
                    case .failure(let error): self?.showError(error)
                    }
                }
            case .failure(let error): self?.showError(error)
            }
        }
    }

    @objc private func switchToSignUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    @objc private func skipTapped() {
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
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

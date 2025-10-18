import UIKit
import SnapKit
import DesignSystem

class SignInViewController: UIViewController {

    private let viewModel = SignInViewModel()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emailField = LabeledFieldView(title: "E-mail", field: CustomTextField(placeholder: "Enter your email"))
    private let passwordField = LabeledFieldView(title: "Password", field: CustomTextField(placeholder: "Enter your password", isSecure: true))

    private let signInButton = UIButton.makeStyled(style: .authPrimary, title: "Sign In")
    private let switchToSignUpButton = UIButton.makeStyled(style: .authSecondary, title: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupActions()
        setupAttributedSignUpText()
    }

    private func setupNavigation() {
        navigationItem.title = "Sign In"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey

        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
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

        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        [emailField, passwordField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(72)
            }
        }

        signInButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }

        view.addSubview(switchToSignUpButton)
        switchToSignUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        switchToSignUpButton.addTarget(self, action: #selector(switchToSignUp), for: .touchUpInside)
    }

    private func setupAttributedSignUpText() {
        let fullText = "Don't have an account yet? Sign Up"
        let attributedText = NSMutableAttributedString(string: fullText)

        // Сначала задаём тёмный цвет и шрифт для всего текста
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedText.addAttribute(.foregroundColor, value: AppColors.arsenicDark, range: fullRange)
        attributedText.addAttribute(.font, value: AppFont.regular18pt(size: 15), range: fullRange)

        // Потом переопределяем цвет для "Login"
        if let range = fullText.range(of: "Sign Up") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: AppColors.customBlue, range: nsRange)
        }
        switchToSignUpButton.setAttributedTitle(attributedText, for: .normal)
    }

    @objc private func signInTapped() {
        viewModel.signIn(email: emailField.text, password: passwordField.text) { [weak self] result in
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

    @objc private func switchToSignUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
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

import UIKit
import SnapKit
import DesignSystem

class ProfileViewController: UIViewController {

    private let viewModel = ProfileViewModel()

    private lazy var headerView = ProfileHeaderView(profile: viewModel.userProfile)

    private lazy var changeTypeButton = makeCustomButton(text: "Type of account", iconName: "chevron.right")
    private lazy var termsButton = makeCustomButton(text: "Terms & Conditions", iconName: "chevron.right")
    private lazy var logoutButton = makeCustomButton(text: "Log out", iconName: "rectangle.portrait.and.arrow.right")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = AppFont.bold_28pt(size: 20)
        label.textColor = AppColors.arsenicDark
        label.textAlignment = .center
        return label
    }()

    private let buttonStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(headerView)
        view.addSubview(buttonStack)

        // Заголовок
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }

        // Аватар, имя, почта
        headerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
        }


        // Обработка нажатия
        headerView.onEditTapped = { [weak self] in
            self?.viewModel.didTapChangePicture()
        }

        // Кнопки внизу
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill

        buttonStack.addArrangedSubview(changeTypeButton)
        buttonStack.addArrangedSubview(termsButton)
        buttonStack.addArrangedSubview(logoutButton)

        buttonStack.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(160)
        }

        // Actions
        changeTypeButton.addTarget(self, action: #selector(didTapChangeType), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.onChangeType = { [weak self] in
            let vc = ChangeTypeViewController()
            self?.present(vc, animated: true)
        }

        viewModel.onChangePicture = { [weak self] in
            let vc = ChangePictureViewController()
            self?.present(vc, animated: true)
        }

        viewModel.onShowTerms = { [weak self] in
            let vc = TermsViewController()
            let navVC = UINavigationController(rootViewController: vc)
            self?.present(navVC, animated: true)
        }

//        viewModel.onLogout = { [weak self] in
//            // логика выхода
//        }
    }

    @objc private func didTapChangeType() {
        viewModel.didTapChangeType()
        print("ChangeType tapped")
    }

    @objc private func didTapTerms() {
        viewModel.didTapTerms()
    }

    @objc private func didTapLogout() {
        viewModel.didTapLogout()
        print("Logout tapped")
    }
}

private func makeCustomButton(text: String, iconName: String) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = AppColors.customBlue
    button.layer.cornerRadius = 12
    button.layer.shadowColor = AppColors.customBlue.withAlphaComponent(0.3).cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 2)
    button.layer.shadowRadius = 4
    button.layer.shadowOpacity = 1
    button.layer.masksToBounds = false

    let label = UILabel()
    label.text = text
    label.textColor = .white
    label.font = AppFont.semiBold_18pt(size: 16)

    let icon = UIImageView(image: UIImage(systemName: iconName))
    icon.tintColor = .white
    icon.contentMode = .scaleAspectFit

    let container = UIView()
    container.isUserInteractionEnabled = false
    container.addSubview(label)
    container.addSubview(icon)

    button.addSubview(container)

    container.snp.makeConstraints {
        $0.edges.equalToSuperview().inset(24)
    }

    label.snp.makeConstraints {
        $0.leading.centerY.equalToSuperview()
    }

    icon.snp.makeConstraints {
        $0.trailing.centerY.equalToSuperview()
        $0.width.height.equalTo(20)
        $0.leading.greaterThanOrEqualTo(label.snp.trailing).offset(100)
    }

    return button
}

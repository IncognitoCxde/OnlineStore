import UIKit
import SnapKit
import DesignSystem

class ProfileHeaderView: UIView {
    private let avatarView = UIImageView()
    private let editIcon = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let infoStack = UIStackView()

    /// Колбэк при нажатии на иконку редактирования
    var onEditTapped: (() -> Void)?

    init(profile: UserProfile) {
        super.init(frame: .zero)
        setup(profile: profile)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(profile: UserProfile) {
        // Аватар
        avatarView.image = UIImage(named: "Avatar")
        avatarView.layer.cornerRadius = 40
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill

        // Иконка редактирования
        editIcon.image = UIImage(named: "pencil")
        editIcon.tintColor = .white
        editIcon.backgroundColor = AppColors.customBlue
        editIcon.layer.cornerRadius = 12
        editIcon.clipsToBounds = true
        editIcon.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapEdit))
        editIcon.addGestureRecognizer(tap)

        // Имя и почта
        nameLabel.text = profile.name
        nameLabel.font = AppFont.semiBold_18pt(size: 16)
        nameLabel.textColor = .black

        emailLabel.text = profile.email
        emailLabel.font = AppFont.regular18pt(size: 14)
        emailLabel.textColor = .gray

        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.alignment = .leading
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(emailLabel)

        // Добавление вьюшек
        addSubview(avatarView)
        addSubview(editIcon)
        addSubview(infoStack)

        // Layout
        avatarView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(80)
        }


        editIcon.snp.makeConstraints {
            $0.bottom.equalTo(avatarView.snp.bottom).offset(4)
            $0.trailing.equalTo(avatarView.snp.trailing).offset(4)
            $0.size.equalTo(24)
        }

        infoStack.snp.makeConstraints {
            $0.leading.equalTo(avatarView.snp.trailing).offset(16)
            $0.centerY.equalTo(avatarView.snp.centerY)
            $0.trailing.equalToSuperview()
        }

        self.snp.makeConstraints {
            $0.height.equalTo(avatarView.snp.height)
        }
    }

    @objc private func didTapEdit() {
        onEditTapped?()
    }
}

import UIKit
import SnapKit
import DesignSystem
import SDWebImage

class ProfileHeaderView: UIView {
    private let avatarView = UIImageView()
    private let editIcon = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let infoStack = UIStackView()

    var onEditTapped: (() -> Void)?

    init(profile: UserProfile) {
        super.init(frame: .zero)
        setup(profile: profile)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(profile: UserProfile) {
        avatarView.image = UIImage(named: "Avatar")
        avatarView.layer.cornerRadius = 40
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill

        editIcon.image = UIImage(named: "pencil")
        editIcon.tintColor = .white
        editIcon.backgroundColor = AppColors.customBlue
        editIcon.layer.cornerRadius = 12
        editIcon.clipsToBounds = true
        editIcon.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapEdit))
        editIcon.addGestureRecognizer(tap)

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

        addSubview(avatarView)
        addSubview(editIcon)
        addSubview(infoStack)

        avatarView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
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

    func setAvatar(image: UIImage) {
        avatarView.image = image
    }

    func setAvatar(url: String?) {
        guard let url = url, let imageURL = URL(string: url) else { return }
        avatarView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "Avatar"))
    }

    func update(name: String?, email: String?) {
        nameLabel.text = name ?? "No name"
        emailLabel.text = email ?? "No email"
    }
}

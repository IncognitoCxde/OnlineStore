import UIKit
import SnapKit
import DesignSystem
import FirebaseAuth
import FirebaseFirestore

class ChangeTypeViewController: UIViewController {

    private let card = UIView()
    var onTypeChanged: ((UserAccountType) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        card.backgroundColor = AppColors.lightGrey
        card.layer.cornerRadius = 16
        view.addSubview(card)

        let titleLabel = UILabel()
        titleLabel.text = "Change account type"
        titleLabel.font = AppFont.semiBold_18pt(size: 18)
        titleLabel.textAlignment = .center

        let clientButton = UIButton.makeIconButton(text: "Client", icon: AppIcons.client)
        let managerButton = UIButton.makeIconButton(text: "Manager", icon: AppIcons.manager)

        [titleLabel, clientButton, managerButton].forEach { card.addSubview($0) }

        card.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        clientButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        managerButton.snp.makeConstraints {
            $0.top.equalTo(clientButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        clientButton.addTarget(self, action: #selector(didTapClient), for: .touchUpInside)
        managerButton.addTarget(self, action: #selector(didTapManager), for: .touchUpInside)
    }

    @objc private func didTapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !card.frame.contains(location) {
            dismiss(animated: true)
        }
    }

    @objc private func didTapClient() {
        changeAccountType(UserAccountType.client)
    }

    @objc private func didTapManager() {
        changeAccountType(UserAccountType.manager)
    }

    private func changeAccountType(_ type: UserAccountType) {
        guard let uid = UserSession.shared.userID else { return }

        Firestore.firestore().collection("users").document(uid).updateData([
            "accountType": type.rawValue
        ]) { error in
            if let error = error {
                print("Failed to update account type: \(error.localizedDescription)")
            } else {
                UserSession.shared.updateAccountType(type)
                self.onTypeChanged?(type)
                self.dismiss(animated: true)
            }
        }
    }
}

private extension UIButton {
    static func makeIconButton(
        text: String,
        icon: UIImage,
        textColor: UIColor = AppColors.arsenicDark,
        backgroundColor: UIColor = AppColors.lightGrey,
        borderColor: UIColor? = nil
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = text
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = textColor
        config.image = icon
        config.imagePlacement = .leading
        config.imagePadding = 12
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        let button = UIButton(configuration: config)
        button.titleLabel?.font = AppFont.bold_24pt(size: 14)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .leading

        if let borderColor = borderColor {
            button.layer.borderWidth = 1
            button.layer.borderColor = borderColor.cgColor
        }

        return button
    }
}

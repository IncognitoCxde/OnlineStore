import UIKit
import SnapKit
import DesignSystem

class ChangePictureViewController: UIViewController {

    private let card = UIView()

    var onTakePhoto: (() -> Void)?
    var onChooseFile: (() -> Void)?
    var onDeletePhoto: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        view.addSubview(card)

        let titleLabel = UILabel()
        titleLabel.text = "Change your picture"
        titleLabel.font = AppFont.semiBold_18pt(size: 18)
        titleLabel.textAlignment = .center

        let takePhotoButton = UIButton.makeIconButton(text: "Take a photo", icon: AppIcons.camera)
        let chooseFileButton = UIButton.makeIconButton(text: "Choose from your file", icon: AppIcons.folderMinus)
        let deleteButton = UIButton.makeIconButton(
            text: "Delete photo",
            icon: AppIcons.trash,
            textColor: .red,
            borderColor: .red
        )

        [titleLabel, takePhotoButton, chooseFileButton, deleteButton].forEach { card.addSubview($0) }

        card.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(280)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        takePhotoButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        chooseFileButton.snp.makeConstraints {
            $0.top.equalTo(takePhotoButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        deleteButton.snp.makeConstraints {
            $0.top.equalTo(chooseFileButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        takePhotoButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        chooseFileButton.addTarget(self, action: #selector(didTapChooseFile), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }

    @objc private func didTapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !card.frame.contains(location) {
            dismiss(animated: true)
        }
    }

    @objc private func didTapTakePhoto() {
        dismiss(animated: true) { self.onTakePhoto?() }
    }

    @objc private func didTapChooseFile() {
        dismiss(animated: true) { self.onChooseFile?() }
    }

    @objc private func didTapDelete() {
        dismiss(animated: true) { self.onDeletePhoto?() }
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
        button.titleLabel?.font = AppFont.black_24pt(size: 16)
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

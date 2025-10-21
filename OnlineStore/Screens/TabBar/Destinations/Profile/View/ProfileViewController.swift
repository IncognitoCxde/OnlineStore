import UIKit
import SnapKit
import DesignSystem
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

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
    private let guestView = GuestView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let uid = UserSession.shared.userID, !uid.isEmpty {
            showProfileContent()
            headerView.update(name: UserSession.shared.name, email: UserSession.shared.email)
            headerView.setAvatar(url: UserSession.shared.photoURL)
        } else {
            showGuestState()
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(headerView)
        view.addSubview(buttonStack)
        view.addSubview(guestView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
        
        // Карандашик → открываем кастомный ChangePictureViewController
        headerView.onEditTapped = { [weak self] in
            let vc = ChangePictureViewController()
            vc.onTakePhoto = { [weak self] in
                self?.presentImagePicker(sourceType: .camera)
            }
            vc.onChooseFile = { [weak self] in
                self?.presentImagePicker(sourceType: .photoLibrary)
            }
            vc.onDeletePhoto = { [weak self] in
                self?.deleteAvatar()
            }
            self?.present(vc, animated: true)
        }
        
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
        }
        
        changeTypeButton.addTarget(self, action: #selector(didTapChangeType), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        
        // GuestView
        guestView.snp.makeConstraints { $0.edges.equalToSuperview() }
        guestView.isHidden = true
        guestView.actionButton.addTarget(self, action: #selector(didTapAuth), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onShowTerms = { [weak self] in
            let vc = TermsViewController()
            let navVC = UINavigationController(rootViewController: vc)
            self?.present(navVC, animated: true)
        }
    }
    
    // MARK: - Guest / Profile states
    
    private func showProfileContent() {
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.headerView.isHidden = false
            self.buttonStack.isHidden = false
            self.guestView.isHidden = true
        })
    }

    private func showGuestState() {
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.headerView.isHidden = true
            self.buttonStack.isHidden = true
            self.guestView.isHidden = false
        })
    }
    
    @objc private func didTapAuth() {
        let signInVC = SignInViewController()
        let nav = UINavigationController(rootViewController: signInVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - Работа с фото
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func uploadAvatarToStorage(_ image: UIImage) {
        guard let uid = UserSession.shared.userID,
              let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = Storage.storage().reference().child("avatars/\(uid).jpg")
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Upload failed: \(error)")
                return
            }
            
            storageRef.downloadURL { url, _ in
                guard let url = url else { return }
                Firestore.firestore().collection("users").document(uid).updateData([
                    "photoURL": url.absoluteString
                ])
                UserSession.shared.updatePhotoURL(url.absoluteString)
            }
        }
    }
    
    private func deleteAvatar() {
        guard let uid = UserSession.shared.userID else { return }
        let storageRef = Storage.storage().reference().child("avatars/\(uid).jpg")
        storageRef.delete { _ in }
        
        Firestore.firestore().collection("users").document(uid).updateData([
            "photoURL": FieldValue.delete()
        ])
        UserSession.shared.updatePhotoURL(nil)
        headerView.setAvatar(image: UIImage(named: "Avatar")!)
    }
    
    // MARK: - Actions
    
    @objc private func didTapChangeType() {
        let vc = ChangeTypeViewController()
        vc.onTypeChanged = { [weak self] newType in
            self?.showSuccess(message: "Account type changed to \(newType.rawValue)")
            if let tabBar = self?.tabBarController as? TabBarController {
                tabBar.rebuildTabs()
                if newType == .manager {
                    tabBar.selectedIndex = 2
                }
            }
        }
        present(vc, animated: true)
    }
    
    @objc private func didTapTerms() {
        viewModel.didTapTerms()
    }
    
    @objc private func didTapLogout() {
        do {
            try Auth.auth().signOut()
            UserSession.shared.clear()
            showGuestState()
        } catch {
            showError(error)
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
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            headerView.setAvatar(image: editedImage)
            uploadAvatarToStorage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            headerView.setAvatar(image: originalImage)
            uploadAvatarToStorage(originalImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

import Foundation

class ProfileViewModel {
    var onChangeType: (() -> Void)?
    var onChangePicture: (() -> Void)?
    var onShowTerms: (() -> Void)?
    var onLogout: (() -> Void)?

    let userProfile = UserProfile(
        name: "iCodePro Developer",
        email: "icodepro@gmail.com",
        avatarImageName: "avatar"
    )

    func didTapChangeType() {
        onChangeType?()
    }

    func didTapChangePicture() {
        onChangePicture?()
    }

    func didTapTerms() {
        onShowTerms?()
    }

    func didTapLogout() {
        onLogout?()
    }
}

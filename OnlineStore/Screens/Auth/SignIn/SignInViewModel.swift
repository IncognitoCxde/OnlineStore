import Foundation

class SignInViewModel {

    func signIn(email: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseService.shared.signIn(email: email, password: password, completion: completion)
    }
}

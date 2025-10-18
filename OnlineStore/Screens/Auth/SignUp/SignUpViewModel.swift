import Foundation

final class SignUpViewModel {

    func signUp(
        name: String?,
        email: String?,
        password: String?,
        confirmPassword: String?,
        accountTypeIndex: Int,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let name = name,
              let email = email,
              let password = password,
              let confirmPassword = confirmPassword,
              !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            completion(.failure(AuthError.missingFields))
            return
        }

        guard password == confirmPassword else {
            completion(.failure(AuthError.passwordMismatch))
            return
        }

        let accountType: AccountType = accountTypeIndex == 0 ? .client : .manager

        FirebaseService.shared.signUp(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            accountType: accountType,
            completion: completion
        )
    }
}

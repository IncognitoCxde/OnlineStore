import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseService {

    static let shared = FirebaseService()
    private let db = Firestore.firestore()

    private init() {}

    func signIn(email: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = email, let password = password, !email.isEmpty, !password.isEmpty else {
            print("signIn: Missing fields")
            completion(.failure(AuthError.missingFields))
            return
        }

        print("signIn: Attempting login with email: \(email)")
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("signIn error: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("signIn success: \(result?.user.email ?? "unknown email")")
                completion(.success(()))
            }
        }
    }

    func signUp(name: String?, email: String?, password: String?, confirmPassword: String?, accountType: AccountType, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let name = name, let email = email, let password = password, let confirmPassword = confirmPassword,
              !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            print("signUp: Missing fields")
            completion(.failure(AuthError.missingFields))
            return
        }

        guard password == confirmPassword else {
            print("signUp: Passwords do not match")
            completion(.failure(AuthError.passwordMismatch))
            return
        }

        print("signUp: Creating user with email: \(email)")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("signUp error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let uid = result?.user.uid else {
                print("signUp: UID is nil")
                completion(.failure(AuthError.unknown))
                return
            }

            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "accountType": accountType.rawValue
            ]
            print("signUp: Saving user data to Firestore for UID: \(uid)")
            print("Data: \(userData)")

            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    print("Firestore error: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Firestore save success for UID: \(uid)")
                    completion(.success(()))
                }
            }
        }
    }
}

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum UserAccountType: String {
    case client
    case manager
}

final class UserSession {
    static let shared = UserSession()

    private(set) var accountType: UserAccountType?
    private(set) var userID: String?
    private(set) var name: String?
    private(set) var email: String?
    private(set) var photoURL: String?

    private init() {}

    func updateAccountType(_ type: UserAccountType) {
        self.accountType = type
    }

    func updatePhotoURL(_ url: String?) {
        self.photoURL = url
    }

    func loadUser(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(SessionError.noUser))
            return
        }

        userID = uid

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data(),
                  let rawType = data["accountType"] as? String,
                  let type = UserAccountType(rawValue: rawType) else {
                completion(.failure(SessionError.invalidData))
                return
            }

            self.accountType = type
            self.name = data["name"] as? String
            self.email = data["email"] as? String
            self.photoURL = data["photoURL"] as? String

            completion(.success(()))
        }
    }

    func clear() {
        accountType = nil
        userID = nil
        name = nil
        email = nil
        photoURL = nil
    }
}

enum SessionError: LocalizedError {
    case noUser
    case invalidData

    var errorDescription: String? {
        switch self {
        case .noUser: return "No user is currently signed in."
        case .invalidData: return "Failed to load user data."
        }
    }
}

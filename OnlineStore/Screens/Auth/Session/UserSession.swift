import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserSession {

    static let shared = UserSession()

    private(set) var accountType: AccountType?
    private(set) var userID: String?

    private init() {}

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
                  let type = AccountType(rawValue: rawType) else {
                completion(.failure(SessionError.invalidData))
                return
            }

            self.accountType = type
            completion(.success(()))
        }
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

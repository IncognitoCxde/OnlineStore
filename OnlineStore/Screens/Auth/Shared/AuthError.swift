import Foundation

enum AuthError: LocalizedError {
    case missingFields
    case passwordMismatch
    case weakPassword
    case invalidEmail
    case userNotFound
    case wrongPassword
    case unknown

    var errorDescription: String? {
        switch self {
        case .missingFields:
            return "Please fill in all fields."
        case .passwordMismatch:
            return "Passwords do not match."
        case .weakPassword:
            return "Password is too weak."
        case .invalidEmail:
            return "Invalid email format."
        case .userNotFound:
            return "User not found."
        case .wrongPassword:
            return "Incorrect password."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}

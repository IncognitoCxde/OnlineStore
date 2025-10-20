import Foundation

struct PasswordValidator {
    static func isValid(_ password: String) -> Bool {
        return hasMinimumLength(password)
            && containsLetter(password)
            && containsDigit(password)
    }

    static func hasMinimumLength(_ password: String) -> Bool {
        return password.count >= 8
    }

    static func containsLetter(_ password: String) -> Bool {
        return password.range(of: "[A-Za-z]", options: .regularExpression) != nil
    }

    static func containsDigit(_ password: String) -> Bool {
        return password.range(of: "[0-9]", options: .regularExpression) != nil
    }

    static func validationErrors(for password: String) -> [String] {
        var errors: [String] = []
        if !hasMinimumLength(password) { errors.append("Minimum 8 characters") }
        if !containsLetter(password) { errors.append("At least one letter") }
        if !containsDigit(password) { errors.append("At least one digit") }
        return errors
    }
}

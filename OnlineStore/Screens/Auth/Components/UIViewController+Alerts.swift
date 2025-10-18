import UIKit

extension UIViewController {

    func showAlert(title: String = "Oops", message: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        present(alert, animated: true)
    }

    func showError(_ error: Error, title: String = "Error") {
        showAlert(title: title, message: error.localizedDescription)
    }

    func showSuccess(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}


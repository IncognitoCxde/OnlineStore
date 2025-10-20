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

    // Добавлена поддержка autoDismissInterval
    func showSuccess(message: String, autoDismissInterval: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true) {
            guard let interval = autoDismissInterval else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
                guard self != nil else { return }
                if alert.presentingViewController != nil {
                    alert.dismiss(animated: true) {
                        completion?()
                    }
                }
            }
        }
    }
}

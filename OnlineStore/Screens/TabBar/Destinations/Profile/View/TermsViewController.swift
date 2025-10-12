import UIKit
import SnapKit
import DesignSystem

class TermsViewController: UIViewController {
    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setupNavigationBar()
        setupTextView()
    }

    private func setupNavigationBar() {
        // Заголовок
        title = "Terms & Conditions"

        // Кнопка "Назад"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = AppColors.customBlue
    }

    private func setupTextView() {
        textView.text = """
        Welcome to OnlineStore. By using our app or making a purchase, you agree to these terms.
            •    Orders: All orders are subject to availability and confirmation.
            •    Payments: We accept online payments by bank cards. Prices are shown in TJS/USD.
            •    Shipping: Delivery times may vary depending on location.
            •    Returns: You can return items within 14 days in original condition.
            •    Privacy: We respect your privacy. Your personal data is used only to process orders.
            •    Liability: We are not responsible for any indirect or accidental damages.
            •    Law: These terms are governed by the laws of Tajikistan.

        Contact us: icodepro@gmail.com | Blue Team
        """
        textView.font = AppFont.regular18pt(size: 16)
        textView.textColor = AppColors.arsenicDark
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear

        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }

    @objc private func didTapBack() {
        dismiss(animated: true)
    }
}

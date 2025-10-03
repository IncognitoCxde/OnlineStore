import UIKit
import DesignSystem
import SnapKit

extension UIButton {
    static func makeStyledButton(
        text: String,
        fontSize: CGFloat = 14,
        cornerRadius: CGFloat = 12,
        backgroundColor: UIColor = AppColors.lightGrey,
        textColor: UIColor = .black,
        borderWidth: CGFloat = 0.3,
        borderColor: UIColor = AppColors.babyBlue,
        shadowColor: UIColor = AppColors.customBlue.withAlphaComponent(0.3),
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowRadius: CGFloat = 4,
        shadowOpacity: Float = 1
    ) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = text
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = textColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)

        let button = UIButton(configuration: config)
        button.titleLabel?.font = AppFont.black_24pt(size: fontSize)
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.cgColor
        button.clipsToBounds = false
        button.layer.masksToBounds = false

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

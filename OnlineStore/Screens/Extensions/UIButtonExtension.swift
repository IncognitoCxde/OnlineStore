import UIKit
import DesignSystem

extension UIButton {
    static func makeStyled(style: ButtonStyle, title: String) -> UIButton {
        let config = style.config
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(config.textColor, for: .normal)
        button.titleLabel?.font = AppFont.medium_18pt(size: config.fontSize)
        button.backgroundColor = config.backgroundColor
        button.layer.cornerRadius = config.cornerRadius
        button.layer.borderWidth = config.borderWidth
        button.layer.borderColor = config.borderColor.cgColor
        button.layer.shadowColor = config.shadowColor.cgColor
        button.layer.shadowOffset = config.shadowOffset
        button.layer.shadowRadius = config.shadowRadius
        button.layer.shadowOpacity = config.shadowOpacity
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false

        if let height = config.fixedHeight {
            button.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let minWidth = config.minWidth {
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        }

        return button
    }
}

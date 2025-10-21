import UIKit
import DesignSystem

enum ButtonStyle {
    case authPrimary
    case authSecondary
    case onboardingAction

    var config: ButtonConfig {
        switch self {
        case .authPrimary:
            return ButtonConfig(
                fontSize: 16,
                cornerRadius: 14,
                backgroundColor: AppColors.customBlue,
                textColor: .white,
                borderWidth: 0,
                borderColor: .clear,
                shadowColor: AppColors.customBlue.withAlphaComponent(0.2),
                shadowOffset: CGSize(width: 0, height: 1),
                shadowRadius: 3,
                shadowOpacity: 0.8,
                contentInsets: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24),
                fixedHeight: 52,
                minWidth: nil
            )
        case .authSecondary:
            return ButtonConfig(
                fontSize: 14,
                cornerRadius: 10,
                backgroundColor: AppColors.lightGrey,
                textColor: AppColors.customBlue,
                borderWidth: 0,
                borderColor: .clear,
                shadowColor: .clear,
                shadowOffset: .zero,
                shadowRadius: 0,
                shadowOpacity: 0,
                contentInsets: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24),
                fixedHeight: 48,
                minWidth: nil
            )
        case .onboardingAction:
            return ButtonConfig(
                fontSize: 14,
                cornerRadius: 12,
                backgroundColor: AppColors.lightGrey,
                textColor: AppColors.arsenicDark,
                borderWidth: 0.3,
                borderColor: AppColors.babyBlue,
                shadowColor: AppColors.customBlue.withAlphaComponent(0.3),
                shadowOffset: CGSize(width: 0, height: 2),
                shadowRadius: 4,
                shadowOpacity: 1,
                contentInsets: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24),
                fixedHeight: 52,
                minWidth: 160
            )
        }
    }
}

struct ButtonConfig {
    let fontSize: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: UIColor
    let textColor: UIColor
    let borderWidth: CGFloat
    let borderColor: UIColor
    let shadowColor: UIColor
    let shadowOffset: CGSize
    let shadowRadius: CGFloat
    let shadowOpacity: Float
    let contentInsets: UIEdgeInsets
    let fixedHeight: CGFloat?
    let minWidth: CGFloat?
}

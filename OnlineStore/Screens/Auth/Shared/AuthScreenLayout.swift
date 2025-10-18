import UIKit
import SnapKit
import DesignSystem

final class AuthScreenLayout: UIView {

    init(fields: [UIView], actionButton: UIButton, bottomButton: UIButton) {
        super.init(frame: .zero)

        let stack = UIStackView(arrangedSubviews: fields + [actionButton, bottomButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill

        addSubview(stack)
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    required init?(coder: NSCoder) { fatalError() }
}


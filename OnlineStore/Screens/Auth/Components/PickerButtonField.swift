import UIKit
import SnapKit
import DesignSystem

final class PickerButtonField: UIView {

    private let label = UILabel()

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var onTap: (() -> Void)?

    init(placeholder: String) {
        super.init(frame: .zero)
        setupUI(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(placeholder: String) {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = AppColors.grey.cgColor
        backgroundColor = AppColors.lightGrey

        label.text = placeholder
        label.font = AppFont.regular18pt(size: 17)
        label.textColor = AppColors.mediumGrey

        addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGesture)
    }

    @objc private func tapped() {
        onTap?()
    }
}

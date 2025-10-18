import UIKit
import SnapKit
import DesignSystem

final class LabeledFieldView: UIView {

    private let titleLabel = UILabel()
    let field: UIView

    init(title: String, field: UIView) {
        self.field = field
        super.init(frame: .zero)
        setupUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        titleLabel.text = title
        titleLabel.font = AppFont.regular18pt(size: 14)
        titleLabel.textColor = AppColors.grey
        titleLabel.backgroundColor = AppColors.lightGrey
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        field.setContentHuggingPriority(.required, for: .vertical)
        field.setContentCompressionResistancePriority(.required, for: .vertical)

        let stack = UIStackView(arrangedSubviews: titleLabel.text?.isEmpty == false ? [titleLabel, field] : [field])
        stack.axis = .vertical
        stack.spacing = titleLabel.text?.isEmpty == false ? 4 : 0
        stack.alignment = .fill
        stack.distribution = .fill

        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    var text: String? {
        if let tf = field as? CustomTextField {
            return tf.text
        } else if let pf = field as? PickerButtonField {
            return pf.text
        }
        return nil
    }

    override var inputView: UIView? {
        if let tf = field as? CustomTextField {
            return tf.inputView
        } else if let pf = field as? PickerButtonField {
            return pf.inputView
        }
        return nil
    }
}

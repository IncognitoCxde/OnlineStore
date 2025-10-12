import UIKit
import SnapKit
import DesignSystem

class WishlistCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let heartButton = UIButton()
    var onHeartTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        contentView.backgroundColor = AppColors.lightGrey
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        contentView.clipsToBounds = false
        layer.masksToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        heartButton.setImage(AppIcons.heartActive, for: .normal)
        heartButton.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)

        titleLabel.font = AppFont.black_24pt(size: 14)
        titleLabel.numberOfLines = 2

        priceLabel.font = AppFont.bold_24pt(size: 16)
        priceLabel.textColor = AppColors.customBlue

        [imageView, titleLabel, priceLabel, heartButton].forEach { contentView.addSubview($0) }

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(8)
        }

        heartButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(priceLabel)
            $0.size.equalTo(24)
        }
    }

    func configure(with item: FavoriteItem) {
        imageView.image = UIImage(named: item.imageName ?? "placeholder")
        titleLabel.text = item.title
        priceLabel.text = String(format: "$%.2f", item.price)
    }

    @objc private func didTapHeart() {
        onHeartTapped?()
    }
}

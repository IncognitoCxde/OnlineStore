import UIKit
import SnapKit
import DesignSystem

final class OnboardingContentViewController: UIViewController {
    
    let slide: OnboardingSlide
    var isLastSlide: Bool = false
    
    var onNextTapped: (() -> Void)?
    var onGetStartedTapped: (() -> Void)?
    
    var slideTitle: String {
        return slide.title
    }
    
    // MARK: - UI
    
    private let imageWrapper = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let buttonContainer = UIView()
    private let actionButton = UIButton.makeStyledButton(text: "Next")
    
    // MARK: - Init
    
    init(slide: OnboardingSlide) {
        self.slide = slide
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        detailsUI()
        setUpConstraints() 
        configure(with: slide)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyShadow(to: buttonContainer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateButtonWiggle(actionButton)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey
        view.clipsToBounds = false
        
        view.addSubview(imageWrapper)
        imageWrapper.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(buttonContainer)
        
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    }
    
    private func detailsUI() {
        imageWrapper.backgroundColor = .clear
        imageWrapper.layer.masksToBounds = false
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = false
        
        titleLabel.font = AppFont.bold_28pt(size: 38)
        titleLabel.textColor = AppColors.customBlue
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 3
        
        descriptionLabel.font = AppFont.black_24pt(size: 18)
        descriptionLabel.textColor = AppColors.grey
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 1
        
        actionButton.setTitle("Next", for: .normal)
        actionButton.backgroundColor = .white
        actionButton.layer.cornerRadius = 12
        actionButton.clipsToBounds = false
        actionButton.layer.masksToBounds = false
//        actionButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        buttonContainer.backgroundColor = .clear
        buttonContainer.clipsToBounds = false
        buttonContainer.layer.masksToBounds = false
        buttonContainer.addSubview(actionButton)
        
        actionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpConstraints() {
        imageWrapper.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageWrapper.snp.width).multipliedBy(1.4)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
    
    // MARK: - Shadow
    
    private func applyShadow(to view: UIView) {
        view.layer.shadowColor = AppColors.customBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 6, height: 6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.7
        view.layer.masksToBounds = false
    }
    
    // MARK: - Wiggle Animation
    
    private func animateButtonWiggle(_ button: UIButton) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.values = [0, -4, 4, -3, 3, -2, 2, 0, 0, 0] 
        animation.keyTimes = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.9, 1.0] as [NSNumber]
        animation.duration = 2.4
        animation.repeatCount = .infinity
        button.layer.add(animation, forKey: "wiggle")
    }

    
    // MARK: - Configuration
    
    private func configure(with slide: OnboardingSlide) {
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description
        imageView.image = slide.image
        
        let buttonTitle = isLastSlide ? "Get Started" : "Next"
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func actionTapped() {
        if isLastSlide {
            onGetStartedTapped?()
        } else {
            onNextTapped?()
        }
    }
}

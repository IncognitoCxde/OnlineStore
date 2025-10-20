//  CartViewController

// MARK: - Imports

import UIKit
import DesignSystem

class CartViewController: UIViewController {
    
    // MARK: - Variables
    
    let viewModel = CartViewModel()
    
    let titleLabel = UILabel()
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
        
    private let deliveryLabel = UILabel()
    private let locationButton = UIButton(type: .system)

    private let summaryView = UIView()
    private let summaryTitleLabel = UILabel()
    private let totalTitleLabel = UILabel()
    private let totalValueLabel = UILabel()
    private let paymentButton = UIButton(type: .system)


    let tableView = UITableView()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUp()
    }
    
    // MARK: - Set up Nav
    
    func setUp() {
        setUpTitleLabel()
        setUpBackButton()
        setUpConstraints()
        setUpTableView()
        setUpDeliverySection()
        setUpSummaryView()
        setUpSummaryViewConstraints()
    }
    
    func setUpDeliverySection() {
        view.addSubview(deliveryLabel)
        view.addSubview(locationButton)
        
        deliveryLabel.text = "Delivery to"
        deliveryLabel.textColor = AppColors.arsenicDark
        deliveryLabel.font = AppFont.regular18pt(size: 16)
        
        locationButton.setTitle("Salatiga City, Central Java ▾", for: .normal)
        locationButton.setTitleColor(AppColors.arsenicDark, for: .normal)
        locationButton.titleLabel?.font = AppFont.semiBold_18pt(size: 16)
        
        deliveryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        locationButton.snp.makeConstraints { make in
            make.centerY.equalTo(deliveryLabel)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setUpBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.textColor = AppColors.arsenicDark
        titleLabel.font = AppFont.semiBold_18pt(size: 19)
        titleLabel.textAlignment = .center
        titleLabel.text = "Cart"
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true)
    }
    
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(deliveryLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(summaryView.snp.top)
        }
    }
    
    // MARK: - Summary View (payment & total)
    
    func setUpSummaryView() {
        view.addSubview(summaryView)
        summaryView.backgroundColor = .white
        summaryView.layer.cornerRadius = 20
        summaryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        summaryView.layer.shadowColor = UIColor.black.cgColor
        summaryView.layer.shadowOpacity = 0.1
        summaryView.layer.shadowOffset = CGSize(width: 0, height: -2)
        summaryView.layer.shadowRadius = 6

        summaryTitleLabel.text = "Order Summary"
        summaryTitleLabel.font = AppFont.bold_18pt(size: 17)
        summaryTitleLabel.textColor = AppColors.arsenicDark

        totalTitleLabel.text = "Totals"
        totalTitleLabel.font = AppFont.regular18pt(size: 16)
        totalTitleLabel.textColor = AppColors.arsenicDark

        totalValueLabel.text = "$0,00"
        totalValueLabel.font = AppFont.bold_18pt(size: 17)
        totalValueLabel.textColor = AppColors.arsenicDark

        paymentButton.setTitle("Go to payment", for: .normal)
        paymentButton.backgroundColor = AppColors.customBlue
        paymentButton.titleLabel?.font = AppFont.bold_18pt(size: 17)
        paymentButton.tintColor = .white
        paymentButton.layer.cornerRadius = 12

    }
    
    func setUpSummaryViewConstraints() {
        [summaryTitleLabel, totalTitleLabel, totalValueLabel, paymentButton].forEach { summaryView.addSubview($0) }

        summaryView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(150)
        }

        summaryTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
        }

        totalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(summaryTitleLabel)
        }

        totalValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalTitleLabel)
            make.trailing.equalToSuperview().inset(20)
        }

        paymentButton.snp.makeConstraints { make in
            make.top.equalTo(totalTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

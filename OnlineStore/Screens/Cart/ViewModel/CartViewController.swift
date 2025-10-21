//  CartViewController

// MARK: - Imports

import UIKit
import DesignSystem

final class CartViewController: UIViewController {
    
    // MARK: - Variables
    
    let viewModel = CartViewModel()
    
    let titleLabel = UILabel()
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
        
    let deliveryLabel = UILabel()
    let locationButton = UIButton(type: .system)

    let summaryView = UIView()
    let summaryTitleLabel = UILabel()
    let totalTitleLabel = UILabel()
    let totalValueLabel = UILabel()
    let paymentButton = UIButton(type: .system)

    private var dropDownView: DropdownView?
    private var isDropDownVisible = false
    
    
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    let tableView = UITableView()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.lightGrey
        setUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }
    
    // MARK: - Set up
    
    func setUp() {
        setUpTitleLabel()
        setUpBackButton()
        setUpConstraints()
        setUpDeliverySection()
        setUpSummaryView()
        setUpSummaryViewConstraints()
        setUpTableView()

    }
    
    // MARK: - Delivery section (the address n picker)
    
    func setUpDeliverySection() {
        view.addSubview(deliveryLabel)
        view.addSubview(locationButton)
        
        deliveryLabel.text = "Delivery to"
        deliveryLabel.textColor = AppColors.grey
        deliveryLabel.font = AppFont.regular18pt(size: 15)
        
        locationButton.setTitle("Select Delivery Location", for: .normal)
        locationButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        locationButton.tintColor = AppColors.arsenicDark
        locationButton.setTitleColor(AppColors.arsenicDark, for: .normal)
        locationButton.titleLabel?.font = AppFont.medium_18pt(size: 15)
        locationButton.semanticContentAttribute = .forceRightToLeft

        
        deliveryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        locationButton.snp.makeConstraints { make in
            make.centerY.equalTo(deliveryLabel)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Back & Title
    
    func setUpBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
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
    
    // MARK: - Set up TBView
    
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePrices),
            name: .currencyDidChange,
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalLabel), name: .currencyDidChange, object: nil)
        
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
        summaryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        summaryView.layer.shadowColor = UIColor.black.cgColor
        summaryView.layer.shadowOpacity = 0.1
        summaryView.layer.shadowOffset = CGSize(width: 0, height: -2)
        summaryView.layer.shadowRadius = 6

        summaryTitleLabel.text = "Order Summary"
        summaryTitleLabel.font = AppFont.medium_18pt(size: 17)
        summaryTitleLabel.textColor = AppColors.arsenicDark

        totalTitleLabel.text = "Total"
        totalTitleLabel.font = AppFont.regular18pt(size: 16)
        totalTitleLabel.textColor = AppColors.arsenicDark

        totalValueLabel.text = "$0,00"
        totalValueLabel.font = AppFont.medium_18pt(size: 17)
        totalValueLabel.textColor = AppColors.arsenicDark

        paymentButton.setTitle("Go to payment", for: .normal)
        paymentButton.backgroundColor = AppColors.customBlue
        paymentButton.titleLabel?.font = AppFont.medium_18pt(size: 17)
        paymentButton.tintColor = .white
        paymentButton.layer.cornerRadius = 10

    }
    
    // MARK: - Summary section constraints
    
    func setUpSummaryViewConstraints() {
        [summaryTitleLabel, totalTitleLabel, totalValueLabel, paymentButton].forEach { summaryView.addSubview($0) }

        summaryView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(180)
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
    
    // MARK: - Update Cart & reload
    
    @objc func cartUpdated() {
        tableView.reloadData()
        updateTotalLabel()
    }
    
    // MARK: - Location Dropdown
    
    private func showDropdown() {
        let dropdown = DropdownView(items: LocationOption.allCases)
        
        dropdown.didSelectItem = { [weak self] location in
            guard let self = self else { return }
            
            self.locationButton.setTitle(location.rawValue, for: .normal)
            let currency: Currency
            switch location {
            case .taj:
                currency = .tjs
            case .usa:
                currency = .usd
            case .germany:
                currency = .eur
            case .uk:
                currency = .gbp
            case .ua:
                currency = .uah
            }
            
            CurrencyManager.shared.updateCurrency(to: currency) {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .currencyDidChange, object: currency)
                }
            }
            
            UserDefaults.standard.set(location.rawValue, forKey: "selectedLocation")
            UserDefaults.standard.set(currency.rawValue, forKey: "selectedCurrency")
            
            self.hideDropdown()
        }
        view.addSubview(dropdown)
        
        dropdown.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(8)
            make.leading.equalTo(locationButton)
            make.width.equalTo(180)
            make.height.equalTo(200)
        }
        
        dropdown.alpha = 0
        dropdown.transform = CGAffineTransform(translationX: 0, y: -10)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseOut) {
            dropdown.alpha = 1
            dropdown.transform = .identity
        }
        
        dropDownView = dropdown
        isDropDownVisible = true
    }
    
    private func hideDropdown() {
        guard let dropdown = dropDownView else { return }
        UIView.animate(withDuration: 0.25, animations: {
            dropdown.alpha = 0
        }, completion: { _ in
            dropdown.removeFromSuperview()
        })
        dropDownView = nil
        isDropDownVisible = false
    }
    
    // MARK: - OBjc func Select Location
    
    @objc func selectLocation() {
        if isDropDownVisible {
            hideDropdown()
        } else {
            showDropdown()
        }
    }
    
    // MARK: - Total price
    
    @objc func updateTotalLabel() {
        totalValueLabel.text = viewModel.totalPriceString()
        
        UIView.transition(with: totalValueLabel, duration: 0.25, options: .transitionCrossDissolve) {
            self.totalValueLabel.text =  self.viewModel.totalPriceString()
        }
    }
    
    @objc private func updatePrices() {
        tableView.reloadData()
    }
    
    // MARK: - Location Storage

    func restoreLocation() {
        if let savedLocation = UserDefaults.standard.string(forKey: "selectedLocation"),
           let location = LocationOption(rawValue: savedLocation),
           let savedCurrencyRaw = UserDefaults.standard.string(forKey: "selectedCurrency"),
           let savedCurrency = Currency(rawValue: savedCurrencyRaw) {
            
            locationButton.setTitle(location.rawValue, for: .normal)
            
            CurrencyManager.shared.updateCurrency(to: savedCurrency) {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .currencyDidChange, object: savedCurrency)
                }
            }
    }
    }

}

// MARK: Extension Data Source & Delegate

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapTrash(for item: CartItem) {
        viewModel.removeItem(item)
        updateTotalLabel()

    }

    func didChangeQuantity(for item: CartItem, to quantity: Int) {
        CartManager.shared.updateQuantity(for: item, to: quantity)
        tableView.reloadData()
        updateTotalLabel()

    }
    
    

    func didToggleSelection(for item: CartItem) {
        viewModel.toggleSelection(for: item)
        updateTotalLabel()

    }
}


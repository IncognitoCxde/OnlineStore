//  CurrencyManager

import Foundation

final class CurrencyManager {
    static let shared = CurrencyManager()
    
    private init() {}
    
    private(set) var currentCurrency: Currency = .usd
    private var exchangeRates: [String: Double] = [:]
    
    private let networking = CurrencyNetworkingManager()
    private let defaultsKey = "selectedCurrency"
    
    func updateCurrency(to currency: Currency, completion: @escaping () -> Void) {
        currentCurrency = currency
        networking.fetchRates(base: "USD") { [weak self] result in
            switch result {
            case .success(let response):
                self?.exchangeRates = response.conversion_rates
                completion()
            case .failure(let error):
                print(" Failed to fetch rates:", error)
                completion()
            }
        }
    }
    
    func convert(priceInUSD: Double) -> String {
        let code = currentCurrency.rawValue
        let rate = exchangeRates[code] ?? 1.0
        let converted = priceInUSD * rate
        return "\(currentCurrency.symbol) \(String(format: "%.2f", converted))"
    }
    
    func didSelectCurrency(_ currency: Currency) {
        CurrencyManager.shared.updateCurrency(to: currency) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .currencyDidChange, object: nil)
            }
        }
    }
    
    private func saveCurrency() {
        UserDefaults.standard.set(currentCurrency.rawValue, forKey: defaultsKey)
    }
    
    private func loadSavedCurrency() {
        if let savedCode = UserDefaults.standard.string(forKey: defaultsKey),
           let savedCurrency = Currency(rawValue: savedCode) {
            currentCurrency = savedCurrency
        }
    }
}

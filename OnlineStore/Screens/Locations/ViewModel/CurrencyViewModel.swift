//  Currency ViewModel

final class CurrencyViewModel {
    
    static let shared = CurrencyViewModel()
    private let networkingManager = CurrencyNetworkingManager()
    
    private(set) var rates: [String: Double] = [:]
    private(set) var baseCurrency = "USD"
    
    private init() {}
    
    func updateBaseCurrency(to newCurrency: String, completion: @escaping (Bool) -> Void) {
        baseCurrency = newCurrency
        fetchRates(completion: completion)
    }
    
    func fetchRates(completion: @escaping (Bool) -> Void) {
        networkingManager.fetchRates(base: baseCurrency) { [weak self] result in
            switch result {
            case .success(let response):
                self?.rates = response.conversion_rates
                completion(true)
            case .failure(let error):
                print("Failed to fetch currency rates: \(error)")
                completion(false)
            }
        }
    }
    
    func convert(priceUSD: Double, to currencyCode: String) -> Double {
        guard let rate = rates[currencyCode] else { return priceUSD }
        return priceUSD * rate
    }
}

import Foundation

final class FeatureFlagsManager {

    static let shared = FeatureFlagsManager()
    private init() {}

    private let defaults = UserDefaults.standard
    private let featurePrefix = "feature_flag_"

    // MARK: - Feature flags
    enum Flag: String, CaseIterable {
        case newDesign
        case devMode
        // more flags here
    }

    // MARK: - Storage manager
    func isEnabled(_ flag: Flag) -> Bool {
        return defaults.bool(forKey: featurePrefix + flag.rawValue)
    }

    func set(_ flag: Flag, enabled: Bool) {
        defaults.set(enabled, forKey: featurePrefix + flag.rawValue)
    }

    func toggle(_ flag: Flag) {
        let newValue = !isEnabled(flag)
        set(flag, enabled: newValue)
    }

    func resetAll() {
        for flag in Flag.allCases {
            defaults.removeObject(forKey: featurePrefix + flag.rawValue)
        }
    }
}


import UIKit

final class DevModeViewController: UIViewController {

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "DevMode"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let stackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 12
        st.alignment = .fill
        st.distribution = .fill
        return st
    }()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        return v
    }()

    private let resetButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Reset all flags", for: .normal)
        b.setTitleColor(.systemRed, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        b.backgroundColor = .clear
        return b
    }()

    // Keep references to toggles if you need to update them after reset
    private var toggleMap: [FeatureFlagsManager.Flag: UISwitch] = [:]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        configureUI()
        buildFeatureFlagsList()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(resetButton)
    }

    private func setupConstraints() {
        [titleLabel, scrollView, contentView, stackView, resetButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            resetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        resetButton.addTarget(self, action: #selector(resetAllTapped), for: .touchUpInside)
    }

    // MARK: - Build List

    private func buildFeatureFlagsList() {
        // clear previous
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        toggleMap.removeAll()

        for flag in FeatureFlagsManager.Flag.allCases {
            let cell = makeFlagCell(for: flag)
            stackView.addArrangedSubview(cell)
        }
    }

    private func makeFlagCell(for flag: FeatureFlagsManager.Flag) -> UIView {
        // Label
        let label: UILabel = {
            let l = UILabel()
            // make the rawValue more friendly (optional)
            l.text = prettify(flag.rawValue)
            l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            l.textColor = .label
            l.numberOfLines = 1
            return l
        }()

        // Toggle
        let toggle: UISwitch = {
            let s = UISwitch()
            s.isOn = FeatureFlagsManager.shared.isEnabled(flag)
            s.onTintColor = .systemBlue
            s.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
            return s
        }()

        // Keep reference
        toggleMap[flag] = toggle

        // Container and layout
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [label, toggle])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        container.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

        container.tag = flag.hashValue

        return container
    }

    // MARK: - Helpers

    private func prettify(_ raw: String) -> String {
        // turns "newDesign" into "New Design"
        // simple implementation: split camelCase and capitalize
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: raw.count)
        var result = regex?.stringByReplacingMatches(in: raw, options: [], range: range, withTemplate: "$1 $2") ?? raw
        result = result.replacingOccurrences(of: "_", with: " ")
        return result.capitalized
    }

    // MARK: - Actions

    @objc private func toggleChanged(_ sender: UISwitch) {
        // find which flag this switch belongs to
        guard let pair = toggleMap.first(where: { $0.value === sender }) else { return }
        let flag = pair.key
        FeatureFlagsManager.shared.set(flag, enabled: sender.isOn)
    }

    @objc private func resetAllTapped() {
        FeatureFlagsManager.shared.resetAll()
        // refresh UI switches
        for (flag, toggle) in toggleMap {
            toggle.setOn(FeatureFlagsManager.shared.isEnabled(flag), animated: true)
        }
    }
}

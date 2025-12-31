import UIKit
import SnapKit

final class TabBarItemView: UIView {

    var onTap: (() -> Void)?

    // MARK: - UI Elements
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    // MARK: - Init
    init(title: String, icon: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        iconView.image = UIImage(systemName: icon)

        setupUI()
        setupConstraints()
        setupGesture()
        setSelected(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Gesture
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    // MARK: - State
    func setSelected(_ selected: Bool) {
        let color: UIColor = selected ? .systemBlue : .systemGray
        iconView.tintColor = color
        titleLabel.textColor = color
    }

    // MARK: - Action
    @objc private func tapped() {
        onTap?()
    }
}
